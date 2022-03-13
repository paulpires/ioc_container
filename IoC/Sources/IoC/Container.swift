public final class Container {

    private var factories: [String: () -> Any]

    public init() {
        factories = [:]
    }

    public func register<T>(_ factory: @escaping () -> T) {
        let key = "\(T.self)"
        factories[key] = factory
    }

    public func resolve<T>() throws -> T {
        let key = "\(T.self)"
        guard let factory = factories[key] else {
            throw IoCError.missingRegistration(type: T.self)
        }
        return factory() as! T
    }
}
