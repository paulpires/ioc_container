import XCTest
@testable import IoC

final class ResolvedInstancesTests: XCTestCase {

    var sut: ResolvedInstances!
    var stringKey: BlueprintKey!
    var intKey: BlueprintKey!
    var networkKey: BlueprintKey!
    var ephemeralNetworkKey: BlueprintKey!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ResolvedInstances()

        stringKey = BlueprintKey(type: String.self, tag: nil)
        intKey = BlueprintKey(type: Int.self, tag: nil)
        networkKey = BlueprintKey(type: NetworkLayer.self,
                                  tag: .string("network"))
        ephemeralNetworkKey = BlueprintKey(type: NetworkLayer.self,
                                           tag: .string("eNetwork"))
    }

    override func tearDownWithError() throws {
        sut = nil
        stringKey = nil
        intKey = nil
        networkKey = nil
        ephemeralNetworkKey = nil
        try super.tearDownWithError()
    }

    func testSubscriptGetterAndSetter_storesAnyObject() throws {

        let network = Network()
        let ephemeralNetwork = EphemeralNetwork()
        sut[stringKey] = "foobar"
        sut[intKey] = 700
        sut[networkKey] = network
        sut[ephemeralNetworkKey] = ephemeralNetwork
        XCTAssertEqual(sut[stringKey], "foobar")
        XCTAssertEqual(sut[intKey], 700)
        XCTAssertIdentical(sut[networkKey], network)
        XCTAssertIdentical(sut[ephemeralNetworkKey], ephemeralNetwork)
    }

    func testEmpty_removesAllStoredInstances() {
        sut[stringKey] = "foobar"
        sut[intKey] = 700
        XCTAssertEqual(sut[stringKey], "foobar")
        XCTAssertEqual(sut[intKey], 700)
        sut.empty()
        XCTAssertEqual(sut[stringKey], Optional<String>.none)
        XCTAssertEqual(sut[intKey], Optional<Int>.none)
    }
}
