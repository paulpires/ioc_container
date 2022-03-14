import UIKit
import IoC

final class RootNavigationController: UINavigationController {

    init(container: Container) {
        super.init(nibName: nil, bundle: nil)
        let homeViewController = HomeViewController(container: container)
        pushViewController(homeViewController, animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
}
