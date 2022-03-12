import XCTest
@testable import IoC

public final class IoCTests: XCTestCase {
    public func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(IoC().text, "Hello, World!")
    }
}
