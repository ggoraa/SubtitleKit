//
//  WebVTTParserError.swift
//  
//
//  Created by Егор Яковенко on 23.02.2022.
//

import Foundation

public enum WebVTTParserError: Error {
    case headerNotFound
    case badHeaderFormat
    
    case badIndexDeclaration
    case badTimeIntervalDeclaration
    case notFullCaptionDeclaration
}
