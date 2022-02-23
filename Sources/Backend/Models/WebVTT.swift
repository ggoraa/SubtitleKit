//
//  WebVTT.swift
//  
//
//  Created by Егор Яковенко on 23.02.2022.
//

import Foundation

public struct WebVTT {
    public var name: String
    public var body: [WebVTTNode]
}

/// Just a thing that allows me combining different structs in one array lol
public protocol WebVTTNode { }

public struct WebVTTCaption: WebVTTNode {
    public let index: Int
    public let timeInterval: TimeInterval
    public let caption: String
}
