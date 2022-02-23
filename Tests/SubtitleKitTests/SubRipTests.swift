import XCTest
@testable import SubtitleKit
@testable import Backend

class SubRipTests: XCTestCase {
    
    // MARK: - Blanks
    
    func testBlankArrayOnBlankFile() throws {
        let parsed = try SubRip.parseFile(content: "")
        XCTAssert(parsed.isEmpty)
    }
    
    func testBlankArrayOnBlankFileWithSpacesAndNewlines() throws {
        let parsed = try SubRip.parseFile(content: "    \n \n    \n")
        XCTAssert(parsed.isEmpty)
    }
    
    // MARK: - Parsing
    
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
    
    // MARK: - Bad syntax handling
    
    func testBadIndexDeclaration() throws {
        do {
            _ = try SubRip.parseFile(content: """
1 This should not be here!
00:05:00,400 --> 00:05:15,300
This is an example of
a subtitle.
""")
        } catch {
            switch error {
                case SubRipParserError.badIndexDeclaration(let column, let row):
                    XCTAssert(row == 0)
                    XCTAssert(column == 1)
                default:
                    throw XCTIssue(type: .assertionFailure, compactDescription: "Wrong error").associatedError ?? error
            }
        }
    }
    
    func testBadTimeIntervalDeclaration() throws {
        do {
            _ = try SubRip.parseFile(content: """
1
00:0:00,400 --> 00:05:15,3
This is an example of
a subtitle.
""")
        } catch {
            switch error {
                case SubRipParserError.badTimeIntervalDeclaration(let column, let row):
                    XCTAssert(row == 1)
                    XCTAssert(column == 0)
                default:
                    throw XCTIssue(type: .assertionFailure, compactDescription: "Wrong error").associatedError ?? error
            }
        }
    }
    
    func testNotFullNodeDeclaration() throws {
        do {
            _ = try SubRip.parseFile(content: """
1
00:0:00,400 --> 00:05:15,3
""")
        } catch {
            switch error {
                case SubRipParserError.notFullNodeDeclaration(let column, let row):
                    XCTAssert(row == 0)
                    XCTAssert(column == 0)
                default:
                    throw XCTIssue(type: .assertionFailure, compactDescription: "Wrong error").associatedError ?? error
            }
        }
    }
}
