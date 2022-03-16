# IoC

Inversion of Control -- A simple dependency injection container to help decouple your code!

## Introduction

Inversion of Control or the Dependency Inversion Principle (as popularized by Robert C. Martin) declares that high-level modules shouldn’t depend on low-level detail. Instead, both should depend on abstractions.

This framework is aimed at helping you achieve that with as little code as possible. 

### Basic Usage

```swift
import IoC

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let container: Container

    override init() {
        container = Container()
        super.init()
        container.register { Network() as NetworkService }
        container.register { Cache() as CacheService }
        container.register { 
            ImageLoader(
                network: try self.container.resolve(),
                cache: try self.container.resolve()
            ) as ImageService 
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Container will resolve a concrete instance of ImageLoader!
        let imageService = try! container.resolve() as ImageService
    }
}
```

## Roadmap

- [x] Basic dependency object graph resolution with transient objects
- [x] Registering multiple instances of the same abstract type
- [x] Circular dependencies
- [ ] Singletons
- [ ] Runtime arguments
- [ ] Resolving optionals
- [ ] Reset container & de-register types
- [ ] Thread safety
- [ ] Cocoapods & Carthage support

## Examples

Have a look at the example project + playground on how you can use the container. These can be found in the `IoC-example-project/IoC-example-project.xcodeproj` project.

> Note: You may need to build the `IoC` framework before you can use it in the playground. To do that open the example project, select the `IoC` scheme and build for iPhone Simulator.

## Installation

Currently only available as a Swift Package via SPM

## Requirements

- Xcode 13.2+
- Swift 5.5+
- iOS 13+

## Contribution Guide

TBD
