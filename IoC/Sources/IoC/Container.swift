/**
`Container` allows you to register and resolve transient
 dependency object graphs.
*/
public final class Container {

    private var blueprints: [BlueprintKey: Blueprint]
    private var resolvedInstances: ResolvedInstances
    private var recursiveCounter: RecursiveCounter

    /**
     Designated initializer for a Container

     - note: Simply instantiate and its ready for use. You may insantiate multiple
     containers.

     ```swift
     let container = Container()
     ```

     - returns: A new Container.
     */
    public init() {
        blueprints = [:]
        resolvedInstances = ResolvedInstances()
        recursiveCounter = RecursiveCounter()
    }

    /**
     Registers a block containing the instructions for building
     a concrete implementation of a given type.

     - Parameters:
       - tag: Optional tag to uniquely identify this registration. Default is `nil`.
       - factory: Instructions on how to build the type being registered. **Required**.
       - afterInit: Optional block that gets invoked straight after the instance is created
        so that property dependencies.

     - note: It is possible to simply register concrete types.

     - warning: Registering a block for a given type twice will
     override the previous definition. Use tags to uniquely identify multiple
     implementations.

     ```swift
     let container = Container()

     // Network implements NetworkService.
     container.register { Network() as NetworkService }
     // To resolve:
     try container.resolve() as NetworkService

     // Registering multiple implementations for a given type
     container.register(tag: "network") { Network() as NetworkLayer }
     container.register(tag: "ephemeral") { EphemeralNetwork() as NetworkLayer }
     // To resolve:
     try container.resolve(tag: "network") as NetworkLayer
     try container.resolve(tag: "ephemeral") as NetworkLayer

     // Registering circular dependencies:
     container.register { ClientImpl(server: try self.container.resolve()) as Client }
     container.register { ServerImpl() as Server } afterInit: { container, server in
         server.client = try container.resolve() as Client // client property must be weak to avoid a retain cycle
     }
     // To resolve:
     let client = try sut.resolve() as Client
     client.server.client === client // true
     // resolving the dependency that contains the weak
     // property first will result in a broken relationship.
     // i.e., the resolved Client within the afterInit
     // block will be released prematurely.
     
     ```
     */
    public func register<T>(tag: String? = nil,
                            _ factory: @escaping () throws -> T,
                            afterInit: ((Container, T) throws -> Void)? = nil) {

        let key = BlueprintKey(
            type: T.self,
            tag: BlueprintTag(tag)
        )
        blueprints[key] = Blueprint(factory: factory, afterInit: { container, resolved in
            try afterInit?(container, resolved as! T)
        })
    }

    /**
     Resolves an instance implementation of type `T`.

     - Parameters:
       - tag: Optional tag that uniquely identifies a given registration. Default is `nil`.

     - throws: `IoCError.missingRegistration(type: Any.Type)` if the type cannot be resolved.

     - returns: An instance of type `T`.

     ```swift
     let container = Container()

     // Network implements NetworkService.
     container.register { Network() as NetworkService }
     // To resolve:
     try container.resolve() as NetworkService

     // Registering multiple implementations for a given type
     container.register(tag: "network") { Network() as NetworkLayer }
     container.register(tag: "ephemeral") { EphemeralNetwork() as NetworkLayer }
     // To resolve:
     try container.resolve(tag: "network") as NetworkLayer
     try container.resolve(tag: "ephemeral") as NetworkLayer

     // Registering circular dependencies:
     container.register { ClientImpl(server: try self.container.resolve()) as Client }
     container.register { ServerImpl() as Server } afterInit: { container, server in
         server.client = try container.resolve() as Client // client property must be weak to avoid a retain cycle
     }
     // To resolve:
     let client = try sut.resolve() as Client
     client.server.client === client // true
     // resolving the dependency that contains the weak
     // property first will result in a broken relationship.
     // i.e., the resolved Client within the afterInit
     // block will be released prematurely.

     ```
     */
    public func resolve<T>(tag: String? = nil) throws -> T {

        let key = BlueprintKey(
            type: T.self,
            tag: BlueprintTag(tag)
        )

        guard let blueprint = blueprints[key] else {
            throw IoCError.missingRegistration(type: T.self, tag: tag)
        }

        return try recursiveCounter.enter {
            if let previouslyResolved: T = resolvedInstances[key] {
                return previouslyResolved
            }
            let resolved = try blueprint.factory() as! T

            // Because the above factory call can internally resolve dependencies,
            // it could then have already resolved the object we're currently after.
            // Therefore, we return it and throw away the newer object.
            if let resolved: T = resolvedInstances[key] {
                return resolved
            }

            resolvedInstances[key] = resolved
            try blueprint.afterInit?(self, resolved)
            return resolved
        } baseReached: {
            resolvedInstances.empty()
        }
    }
}
