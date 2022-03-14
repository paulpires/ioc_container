import XCTest
@testable import IoC

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

    func testContainer_returnsInstances() throws {

        sut.register { Network() as NetworkLayer }
        let resolved = try sut.resolve() as NetworkLayer
        XCTAssertTrue(resolved is Network)
    }

    func testContainer_returnsNewInstances() throws {

        sut.register { Network() as NetworkLayer }
        let network1 = try sut.resolve() as NetworkLayer
        let network2 = try sut.resolve() as NetworkLayer
        XCTAssertTrue(network1 is Network)
        XCTAssertTrue(network2 is Network)
        XCTAssertNotIdentical(network1, network2)
    }

    func testContainer_overridesPreviousRegistration() throws {

        sut.register { Network() as NetworkLayer }
        let network1 = try sut.resolve() as NetworkLayer
        XCTAssertTrue(network1 is Network)

        sut.register { EphemeralNetwork() as NetworkLayer }
        let network2 = try sut.resolve() as NetworkLayer
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

    func testContainer_canResolveConstructorDependencies() throws {
        sut.register { Network() as NetworkLayer }
        sut.register { CachingServiceImpl(network: try! self.sut.resolve()) as CachingService }
        let cachingService = try sut.resolve() as CachingService
        XCTAssertTrue(cachingService is CachingServiceImpl)
        XCTAssertTrue((cachingService as! CachingServiceImpl).network is Network)
    }

    // MARK: - Multiple implementations for the same protocol type

    func testContainer_resolvesDifferentInstancesGivenATag() throws {

        sut.register(tag: "network") { Network() as NetworkLayer }
        sut.register(tag: "ephemeral") { EphemeralNetwork() as NetworkLayer }

        let network1 = try sut.resolve(tag: "network") as NetworkLayer
        let network2 = try sut.resolve(tag: "ephemeral") as NetworkLayer
        XCTAssertTrue(network1 is Network)
        XCTAssertTrue(network2 is EphemeralNetwork)
    }

    // MARK: - Circular dependencies

    func testContainer_canResolveCircularDependencies() throws {

        sut.register { ClientImpl(server: try! self.sut.resolve()) as Client }
        sut.register { ServerImpl() as Server } afterInit: { container, server in
            server.client = try! container.resolve() as Client
        }

        let client = try sut.resolve() as Client
        XCTAssertTrue(client is ClientImpl)
        XCTAssertIdentical(client.server.client, client)
    }

    func testContainer_circularDependency_doesNotRetainObjects() throws {

        sut.register { ClientImpl(server: try! self.sut.resolve()) as Client }
        sut.register { ServerImpl() as Server } afterInit: { container, server in
            server.client = try! container.resolve() as Client
        }

        let server = try sut.resolve() as Server
        XCTAssertTrue(server is ServerImpl)

        // given the following property is weak and no other object is holding the client strongly,
        // the resolved client within the `afterInit` block will get released.
        XCTAssertNil(server.client)
    }

    func testContainer_doesNotRetainObjects() throws {

        sut.register(tag: "network") { Network() as NetworkLayer }
        sut.register(tag: "ephemeral") { EphemeralNetwork() as NetworkLayer }
        sut.register { CachingServiceImpl(network: try! self.sut.resolve(tag: "network")) as CachingService }
        sut.register { ClientImpl(server: try! self.sut.resolve()) as Client }
        sut.register { ServerImpl() as Server } afterInit: { container, server in
            server.client = try! container.resolve() as Client
        }

        weak var network: NetworkLayer?
        weak var ephemeralNetwork: NetworkLayer?
        weak var cachingService: CachingService?
        weak var client: Client?
        try autoreleasepool
        {
            // retain just within the scope of the autoreleasepool block
            let networkStrongRef = try sut.resolve(tag: "network") as NetworkLayer
            let ephemeralNetworkStrongRef = try sut.resolve(tag: "ephemeral") as NetworkLayer
            let cachingServiceStrongRef = try sut.resolve() as CachingService
            let clientStrongRef = try sut.resolve() as Client

            network = networkStrongRef
            ephemeralNetwork = ephemeralNetworkStrongRef
            cachingService = cachingServiceStrongRef
            client = clientStrongRef

            XCTAssertTrue(network is Network)
            XCTAssertTrue(ephemeralNetwork is EphemeralNetwork)
            XCTAssertTrue(cachingService is CachingServiceImpl)
            XCTAssertTrue(client is ClientImpl)
            XCTAssertIdentical(client?.server.client, client)
        }
        XCTAssertNil(network)
        XCTAssertNil(ephemeralNetwork)
        XCTAssertNil(cachingService)
        XCTAssertNil(client)
    }
}
