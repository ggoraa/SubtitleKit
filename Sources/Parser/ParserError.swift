//
//  ParserError.swift
//  
//
//  Created by Егор Яковенко on 22.02.2022.
//

import Foundation

public enum ParserError: Error {
    case badIndexDeclaration(column: Int, row: Int)
    case badTimeIntervalDeclaration(column: Int, row: Int)
    case notFullNodeDeclaration(column: Int, row: Int)
    
    var message: String {
        switch self {
            case .badIndexDeclaration:
                return "Bad subtitle node declaration"
            case .badTimeIntervalDeclaration:
                return "Bad time interval declaration. Expected format: 'hours:minutes:seconds,milliseconds (00:00:00,000)'"
            case .notFullNodeDeclaration:
                return "A node is not fully declared"
        }
    }
}
