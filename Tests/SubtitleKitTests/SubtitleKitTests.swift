import XCTest
@testable import SubtitleKit

class SubtitleKitTests: XCTestCase {
    func testBlankArrayOnBlankFile() throws {
        print(try SubRip.parseFile(content: ""))
    }
    
    func testBlankArrayOnBlankFileWithSpacesAndNewlines() throws {
        print(try SubRip.parseFile(content: "    \n \n    \n"))
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
        XCTAssert(parsed[0].text == "This is an example of\na subtitle.")
        XCTAssert(parsed[1].index == 2)
        XCTAssert(parsed[1].text == "This is an example of\na subtitle - 2nd subtitle.")
    }
}
