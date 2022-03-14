import XCTest
@testable import IoC

class UtilsTests: XCTestCase {

    func testOptionalDescription_whenNilReturnsNil() throws {
        let string: String? = nil
        XCTAssertEqual(string.description, "nil")
        let int: Int? = nil
        XCTAssertEqual(int.description, "nil")
    }

    func testOptionalDescription_whenNotNilReturnsObjectAsString() throws {
        let string: String? = "Paul"
        XCTAssertEqual(string.description, "Paul")
        let int: Int? = 200
        XCTAssertEqual(int.description, "200")
    }
}
