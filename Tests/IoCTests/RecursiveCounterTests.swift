import XCTest
@testable import IoC

final class RecursiveCounterTests: XCTestCase {

    var sut: RecursiveCounter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RecursiveCounter()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testRecursiveCounter_invokesBaseReachedWhenDepthIsZero() throws {
        var amount = 2
        var baseReached = 0
        func recursiveFunction() {
            sut.enter {
                if amount == 0 {
                    return
                }
                amount -= 1
                recursiveFunction()
            } baseReached: {
                baseReached += 1
            }
        }
        recursiveFunction()
        XCTAssertEqual(baseReached, 1)
    }
}
