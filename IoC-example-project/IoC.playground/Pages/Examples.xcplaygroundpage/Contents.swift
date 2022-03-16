import IoC

let container = Container()

// Network implements NetworkService.
container.register { Network() as NetworkLayer }
// To resolve:
try container.resolve() as NetworkLayer

// Registering multiple implementations for a given type
container.register(tag: "network") { Network() as NetworkLayer }
container.register(tag: "ephemeral") { EphemeralNetwork() as NetworkLayer }
// To resolve:
try container.resolve(tag: "network") as NetworkLayer
try container.resolve(tag: "ephemeral") as NetworkLayer

// Registering circular dependencies:
container.register { ClientImpl(server: try container.resolve()) as Client }
container.register { ServerImpl() as Server } afterInit: { container, server in
    server.client = try container.resolve() as Client // client property must be weak to avoid a retain cycle
}
// To resolve:
let client = try container.resolve() as Client
client.server.client === client // true
// resolving the dependency that contains the weak
// property first will result in a broken relationship.
// i.e., the resolved Client within the afterInit
// block will be released prematurely.
