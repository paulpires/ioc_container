import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            fatalError("missing a UIWindowScene on launch")
        }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = RootNavigationController()
        window.makeKeyAndVisible()
        window.windowScene = scene
        self.window = window
    }
}

