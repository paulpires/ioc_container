import XCTest
@testable import IoC

final class BluePrintTests: XCTestCase {

    func testBluePrintTag_convenienceIniterReturnsCorrectCases() {
        XCTAssertEqual(BlueprintTag("tag"), .string("tag"))
        XCTAssertNil(BlueprintTag(nil))
    }

    func testEqualityOfBluePrints() throws {

        let key1 = BlueprintKey(type: String.self, tag: nil)
        let key2 = BlueprintKey(type: String.self, tag: nil)
        XCTAssertEqual(key1, key2)

        let key3 = BlueprintKey(type: String.self, tag: .string("foobar"))
        let key4 = BlueprintKey(type: String.self, tag: .string("foobar"))
        XCTAssertEqual(key3, key4)

        let key5 = BlueprintKey(type: String.self, tag: .string("foo"))
        let key6 = BlueprintKey(type: String.self, tag: .string("bar"))
        XCTAssertNotEqual(key5, key6)

        let key7 = BlueprintKey(type: String.self, tag: nil)
        let key8 = BlueprintKey(type: Int.self, tag: nil)
        XCTAssertNotEqual(key7, key8)
    }
}
