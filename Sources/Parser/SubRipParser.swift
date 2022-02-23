//
//  SubRipParser.swift
//  
//
//  Created by Егор Яковенко on 22.02.2022.
//

import Foundation

public struct SubRipParser: Parser {
    public typealias Output = SubRipSubtitles
    public typealias Input = String

    public var fileContent: Input
    
    public init(content: Input) {
        self.fileContent = content
    }
    
    public func parse() throws -> Output {
        // First step, split everything by spaces and newlines
        let nodes = fileContent.components(separatedBy: "\n\n")
        var parsedNodes: Output = []
        for (index, node) in nodes.enumerated() {
            // Get all rows
            let nodeRows = node.components(separatedBy: "\n")
            
            // And a basic check whether it is fully declared
            guard nodeRows.count >= 3 else {
                throw ParserError.notFullNodeDeclaration(column: 0, row: index)
            }
            
            guard let nodeIndex = Int(nodeRows[0]) else {
                throw ParserError.badIndexDeclaration(column: 1, row: index)
            }
            
            let timeInterval = try parseTimeInterval(rawString: nodeRows[1], rowOperatedOn: index)
            
            var textRows = nodeRows
            textRows.remove(at: 0)
            textRows.remove(at: 0)
            
            var text = ""
            for (index, row) in textRows.enumerated() {
                text.append(row)
                if index < textRows.count - 1 {
                    text.append(" ")
                }
            }
            
            parsedNodes.append(SubRipNode(
                index: nodeIndex,
                interval: timeInterval,
                text: text
            ))
        }
        return parsedNodes
    }
    
    private func parseTimeInterval(rawString: String, rowOperatedOn row: Int) throws -> DateInterval {
        let split = rawString.components(separatedBy: " ")
        
        // Checks that verifies that the structure is alright
        guard split[0].range(of: #"\d\d:\d\d:\d\d,\d\d\d"#, options: .regularExpression) != nil else {
            throw ParserError.badTimeIntervalDeclaration(
                column: 0,
                row: row
            )
        }
        
        guard split[1] == "-->" else {
            throw ParserError.badTimeIntervalDeclaration(
                column: split[0].count + 1,
                row: row
            )
        }
        
        guard split[2].range(of: #"\d\d:\d\d:\d\d,\d\d\d"#, options: .regularExpression) != nil else {
            throw ParserError.badTimeIntervalDeclaration(
                column: 0,
                row: row
            )
        }
        
        // Everything's alright, then convert everything to dates and
        // combine them into a DateInterval
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss,SSS"
        
        let startDate = dateFormatter.date(from: split[0])!
        let endDate = dateFormatter.date(from: split[2])!
        
        return DateInterval(start: startDate, end: endDate)
    }
}
