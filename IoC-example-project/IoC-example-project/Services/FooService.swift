import Foundation

// MARK: - Foo Service

protocol FooService {
    func giveMeFoo() -> String
}

final class Foo: FooService {

    func giveMeFoo() -> String {
        return "Foo"
    }
}

// MARK: - Bar Service

protocol BarService {
    func giveMeBar() -> String
}
final class Bar: BarService {

    func giveMeBar() -> String {
        return "Bar"
    }
}

// MARK: - FooBar Service

protocol FooBarService {
    func giveMeFooBar() -> String
}
final class FooBar: FooBarService {

    private let foo: FooService
    private let bar: BarService

    init(foo: FooService, bar: BarService) {
        self.foo = foo
        self.bar = bar
    }

    func giveMeFooBar() -> String {
        return "\(foo.giveMeFoo())\(bar.giveMeBar())"
    }
}
