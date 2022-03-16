// MARK: - Multiple implementations for a single protocol

public protocol NetworkLayer: AnyObject {}
public class Network: NetworkLayer {
    public init() {}
}
public class EphemeralNetwork: NetworkLayer {
    public init() {}
}

// MARK: - Object with constructor dependency

public protocol CachingService: AnyObject {}
public class CachingServiceImpl: CachingService {
    public let network: NetworkLayer
    public init(network: NetworkLayer) {
        self.network = network
    }
}

// MARK: - Circular dependency (Server <-> Client)

public protocol Server: AnyObject {
    var client: Client? { get set }
}
public class ServerImpl: Server {
    public weak var client: Client?
    public init() {}
}

public protocol Client: AnyObject {
    var server: Server { get }
}
public class ClientImpl: Client {
    public let server: Server
    public init(server: Server) {
        self.server = server
    }
}

