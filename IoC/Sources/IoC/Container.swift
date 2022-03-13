public final class Container {

    private var blueprints: [Blueprint.Key: Blueprint]

    public init() {
        blueprints = [:]
    }

    public func register<T>(tag: String? = nil,
                            _ factory: @escaping () -> T) {

        let key = Blueprint.Key(
            type: T.self,
            tag: .init(tag)
        )
        blueprints[key] = Blueprint(factory: factory)
    }

    public func resolve<T>(tag: String? = nil) throws -> T {

        let key = Blueprint.Key(
            type: T.self,
            tag: .init(tag)
        )
        guard let blueprint = blueprints[key] else {
            throw IoCError.missingRegistration(type: T.self)
        }
        return blueprint.factory() as! T
    }
}
