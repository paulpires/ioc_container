// MARK: - Multiple implementations for a single protocol

protocol NetworkLayer: AnyObject {}
class Network: NetworkLayer {}
class EphemeralNetwork: NetworkLayer {}

// MARK: - Object with constructor dependency

protocol CachingService: AnyObject {}
class CachingServiceImpl: CachingService {
    let network: NetworkLayer
    init(network: NetworkLayer) {
        self.network = network
    }
}

// MARK: - Circular dependency (Server <-> Client)

protocol Server: AnyObject {
    var client: Client? { get set }
}
class ServerImpl: Server {
    weak var client: Client?
}

protocol Client: AnyObject {
    var server: Server { get }
}
class ClientImpl: Client {
    let server: Server
    init(server: Server) {
        self.server = server
    }
}

