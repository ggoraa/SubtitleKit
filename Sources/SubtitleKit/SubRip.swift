//
//  SubRip.swift
//  
//
//  Created by Егор Яковенко on 22.02.2022.
//

import Parser

public struct SubRip {
    public static func parseFile(content: String) throws -> SubRipSubtitles {
        return try SubRipParser(content: content).parse()
    }
}
