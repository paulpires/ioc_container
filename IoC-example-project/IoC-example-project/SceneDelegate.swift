import UIKit
import IoC

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let container: Container

    override init() {
        container = Container()
        super.init()
        container.register { Foo() as FooService }
        container.register { Bar() as BarService }
        container.register { try FooBar(container: self.container) as FooBarService }
    }

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            fatalError("missing a UIWindowScene on launch")
        }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = RootNavigationController(container: container)
        window.makeKeyAndVisible()
        window.windowScene = scene
        self.window = window
    }
}
