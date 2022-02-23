//
//  WebVTTTests.swift
//  
//
//  Created by Егор Яковенко on 23.02.2022.
//

import XCTest
@testable import SubtitleKit
@testable import Backend

class WebVTTTests: XCTestCase {
    func testBasicParsing() throws {
        let parsed = try WebVTTParser(content: "WEBVTT - Этот файл не содержит реплик.").parse()
        print(parsed)
        XCTAssert(parsed.name == "Этот файл не содержит реплик.")
        XCTAssert(parsed.body.isEmpty)
    }
    
    func testWithCaptionsParsing() throws {
        let parsed = try WebVTTParser(content: """
WEBVTT - Этот файл содержит реплики.

14
00:01:14.815 --> 00:01:18.114
- Что?
- Где мы сейчас?

15
00:01:18.171 --> 00:01:20.991
- Это большая страна летучих мышей.

16
00:01:21.058 --> 00:01:23.868
- [ Визг летучих мышей ]
- Они не попадут в твои волосы. They're after the bugs.
""").parse()
        print(parsed)
        XCTAssert(parsed.name == "Этот файл содержит реплики.")
//        XCTAssert(parsed.body.isEmpty)
    }
}
