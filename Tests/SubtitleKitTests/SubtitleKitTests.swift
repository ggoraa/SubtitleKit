import XCTest
@testable import SubtitleKit

class SubtitleKitTests: XCTestCase {
    /// Should silently stop and return a blank array.
    func testSilentAbortOnBlankFile() throws {
        print(try SubRip.parseFile(content: ""))
    }
    
    func testParsing() throws {
        let parsed = try SubRip.parseFile(content: """
1
00:05:00,400 --> 00:05:15,300
This is an example of
a subtitle.

2
00:05:16,400 --> 00:05:25,300
This is an example of
a subtitle - 2nd subtitle.
""")
        XCTAssert(parsed[0].index == 1)
        XCTAssert(parsed[0].text == "This is an example of a subtitle.")
        XCTAssert(parsed[1].index == 2)
        XCTAssert(parsed[1].text == "This is an example of a subtitle - 2nd subtitle.")
    }
}
