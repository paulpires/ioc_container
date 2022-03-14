public final class Container {

    private var blueprints: [BlueprintKey: Blueprint]
    private var resolvedInstances: ResolvedInstances
    private var recursiveCounter: RecursiveCounter

    public init() {
        blueprints = [:]
        resolvedInstances = ResolvedInstances()
        recursiveCounter = RecursiveCounter()
    }

    public func register<T>(tag: String? = nil,
                            _ factory: @escaping () -> T,
                            afterInit: ((Container, T) -> Void)? = nil) {

        let key = BlueprintKey(
            type: T.self,
            tag: BlueprintTag(tag)
        )
        blueprints[key] = Blueprint(factory: factory, afterInit: { container, resolved in
            afterInit?(container, resolved as! T)
        })
    }

    public func resolve<T>(tag: String? = nil) throws -> T {

        let key = BlueprintKey(
            type: T.self,
            tag: BlueprintTag(tag)
        )

        guard let blueprint = blueprints[key] else {
            throw IoCError.missingRegistration(type: T.self)
        }

        return recursiveCounter.enter {
            if let previouslyResolved: T = resolvedInstances[key] {
                return previouslyResolved
            }
            let resolved = blueprint.factory() as! T

            // Because the above factory call can internally resolve dependencies,
            // it could then have already resolved the object we're currently after.
            // Therefore, we return it and throw away the newer object.
            if let resolved: T = resolvedInstances[key] {
                return resolved
            }

            resolvedInstances[key] = resolved
            blueprint.afterInit?(self, resolved)
            return resolved
        } baseReached: {
            resolvedInstances.empty()
        }
    }
}
