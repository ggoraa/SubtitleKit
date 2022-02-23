//
//  Node.swift
//  
//
//  Created by Егор Яковенко on 22.02.2022.
//

import Foundation

public typealias SubRipSubtitles = [SubRipNode]

public struct SubRipNode {
    public let index: Int
    public let interval: DateInterval
    public let text: String
}
