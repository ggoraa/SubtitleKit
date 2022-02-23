//
//  Parser.swift
//  
//
//  Created by Егор Яковенко on 22.02.2022.
//

import Foundation

/// Base protocol that defines a subtitle file parser.
public protocol Parser {
    associatedtype Output
    associatedtype Input
    
    var fileContent: Input { get }
    
    func parse() throws -> Output
}
