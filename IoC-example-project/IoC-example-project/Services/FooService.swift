import Foundation
import IoC

// MARK: - Foo Service

protocol FooService: AnyObject {
    func giveMeFoo() -> String
}

final class Foo: FooService {

    func giveMeFoo() -> String {
        return "Foo"
    }
}

// MARK: - Bar Service

protocol BarService: AnyObject {
    func giveMeBar() -> String
}
final class Bar: BarService {

    func giveMeBar() -> String {
        return "Bar"
    }
}

// MARK: - FooBar Service

protocol FooBarService: AnyObject {
    func giveMeFooBar() -> String
    var foo: FooService { get }
    var bar: BarService { get }
}
final class FooBar: FooBarService {

    let foo: FooService
    let bar: BarService

    init(container: Container) throws {
        self.foo = try container.resolve()
        self.bar = try container.resolve()
    }

    func giveMeFooBar() -> String {
        return "\(foo.giveMeFoo())\(bar.giveMeBar())"
    }
}
