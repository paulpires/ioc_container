import XCTest
@testable import IoC

protocol NetworkLayer: AnyObject {}
class Network: NetworkLayer {}
class EphemeralNetwork: NetworkLayer {}

protocol CachingService: AnyObject {}
class CachingServiceImpl: CachingService {
    let network: NetworkLayer
    init(network: NetworkLayer) {
        self.network = network
    }
}


final class ContainerTests: XCTestCase {

    var sut: Container!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Container()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testContainer_returnsNewRegisteredImplementation() {

        sut.register { Network() as NetworkLayer }
        let resolved = try! sut.resolve() as NetworkLayer
        XCTAssertTrue(resolved is Network)
    }

    func testContainer_returnsNewInstance() {

        sut.register { Network() as NetworkLayer }
        let network1 = try! sut.resolve() as NetworkLayer
        let network2 = try! sut.resolve() as NetworkLayer
        XCTAssertTrue(network1 is Network)
        XCTAssertTrue(network2 is Network)
        XCTAssertNotIdentical(network1, network2)
    }

    func testContainer_overridesPreviousRegistration() {

        sut.register { Network() as NetworkLayer }
        let network1 = try! sut.resolve() as NetworkLayer
        XCTAssertTrue(network1 is Network)

        sut.register { EphemeralNetwork() as NetworkLayer }
        let network2 = try! sut.resolve() as NetworkLayer
        XCTAssertTrue(network2 is EphemeralNetwork)
    }

    func testContainer_throwsIfNoRegistrationFound() {
        do {
            _ = try sut.resolve() as NetworkLayer
            XCTFail("should throw")
        } catch IoCError.missingRegistration(let something) {
            print(something)
            XCTAssertTrue(something == NetworkLayer.self)
        } catch {
            XCTFail("unexpected error \(error)")
        }
    }

    func testContainer_canResolveConcreteImplementations() {
        sut.register { Network() }
        XCTAssertNoThrow(try sut.resolve() as Network)
    }

    // MARK: - Multiple implementations for the same protocol type

    func testContainer_resolvesDifferentInstancesGivenATag() {

        sut.register(tag: "network") { Network() as NetworkLayer }
        sut.register(tag: "ephemeral") { EphemeralNetwork() as NetworkLayer }

        let network1 = try! sut.resolve(tag: "network") as NetworkLayer
        let network2 = try! sut.resolve(tag: "ephemeral") as NetworkLayer
        XCTAssertTrue(network1 is Network)
        XCTAssertTrue(network2 is EphemeralNetwork)
    }

    func testContainer_canResolveInnerDependencies() {
        sut.register { Network() as NetworkLayer }
        sut.register { CachingServiceImpl(network: try! self.sut.resolve()) as CachingService }
        let cachingService = try! sut.resolve() as CachingService
        XCTAssertTrue(cachingService is CachingServiceImpl)
        XCTAssertTrue((cachingService as! CachingServiceImpl).network is Network)
    }
}
