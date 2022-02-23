//
//  WebVTTParser.swift
//  
//
//  Created by Егор Яковенко on 23.02.2022.
//

import Foundation

public struct WebVTTParser: Parser {
    public typealias Input = String
    public typealias Output = WebVTT
    
    public var fileContent: Input
    
    public init(content: Input) {
        self.fileContent = content
    }
    
    public func parse() throws -> Output {
        // Check whether the file is blank or not
        if fileContent.isBlank {
            throw WebVTTParserError.headerNotFound
        }
        // Declare data containers
        var name = ""
        var body: [WebVTTNode] = []
        
        // This section will parse the header
                
        var components = fileContent.components(separatedBy: "\n\n")
        let header = components[0]
        
        guard header.starts(with: "WEBVTT") else {
            throw WebVTTParserError.badHeaderFormat
        }
        
        var headerHasTitle: Bool
        if header.replacingOccurrences(of: " ", with: "") != "WEBVTT" {
            headerHasTitle = true
        } else {
            headerHasTitle = false
        }
        
        if headerHasTitle {
            var headerTitle = header
            for _ in 0..<9 {
                headerTitle.remove(at: String.Index(
                    utf16Offset: 0,
                    in: headerTitle
                ))
            }
            name = headerTitle
        }
        
        // And this one - the body
        
        components.remove(at: 0)
        for (index, node) in components.enumerated() {
            // Get all rows
            let nodeRows = node.components(separatedBy: "\n")
            
            // And a basic check whether it is fully declared
            guard nodeRows.count >= 3 else {
                throw WebVTTParserError.notFullCaptionDeclaration
            }
            
            guard let nodeIndex = Int(nodeRows[0]) else {
                throw WebVTTParserError.badIndexDeclaration
            }
            
            let timeInterval = try parseTimeInterval(rawString: nodeRows[1], rowOperatedOn: index + 1)
            
            var textRows = nodeRows
            textRows.remove(at: 0)
            textRows.remove(at: 0)
            
            var text = ""
            for (index, row) in textRows.enumerated() {
                text.append(row)
                if index < textRows.count - 1 {
                    text.append("\n")
                }
            }
            
            body.append(WebVTTCaption(
                index: index,
                timeInterval: timeInterval,
                caption: text
            ))
        }
        return WebVTT(name: name, body: body)
    }

    private func parseTimeInterval(rawString: String, rowOperatedOn row: Int) throws -> TimeInterval {
        let split = rawString.components(separatedBy: " ")
        
        // Checks that verifies that the structure is alright
        guard split[0].range(of: #"\d\d:\d\d:\d\d.\d\d\d"#, options: .regularExpression) != nil else {
            throw SubRipParserError.badTimeIntervalDeclaration(
                column: 0,
                row: row
            )
        }
        
        guard split[1] == "-->" else {
            throw SubRipParserError.badTimeIntervalDeclaration(
                column: split[0].count + 1,
                row: row
            )
        }
        
        guard split[2].range(of: #"\d\d:\d\d:\d\d.\d\d\d"#, options: .regularExpression) != nil else {
            throw SubRipParserError.badTimeIntervalDeclaration(
                column: 0,
                row: row
            )
        }
        
        // Everything's alright, then convert everything to dates and
        // combine them into a DateInterval
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss,SSS"
        
        let startDate = timeStop(from: split[0])
        let endDate = timeStop(from: split[2])
        
        return TimeInterval(startStop: startDate, endStop: endDate)
    }
    
    private func timeStop(from string: String) -> TimeStop {
        let components = string.components(
            separatedBy: CharacterSet(
                charactersIn: ":."
            ))
        let ready = components.map { og in
            return Int(og)!
        }
        return TimeStop(
            hours: ready[0],
            minutes: ready[1],
            seconds: ready[2],
            milliseconds: ready[3]
        )
    }
}
