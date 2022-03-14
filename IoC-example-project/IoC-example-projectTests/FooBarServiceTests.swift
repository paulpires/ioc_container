import XCTest
import IoC
@testable import IoC_example_project

class FooBarServiceTests: XCTestCase {

    var sut: FooBar!
    var container: Container!

    override func setUpWithError() throws {
        container = Container()
        container.register { MockFoo() as FooService }
        container.register { MockBar() as BarService }
        sut = try FooBar(container: container)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        container = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testFooBarService_returnsString() throws {
        XCTAssertEqual(sut.giveMeFooBar(), "fakeFoofakeBar")
    }
}

final class MockFoo: FooService {
    func giveMeFoo() -> String {
        return "fakeFoo"
    }
}

final class MockBar: BarService {
    func giveMeBar() -> String {
        return "fakeBar"
    }
}
