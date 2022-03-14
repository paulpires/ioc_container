import UIKit

final class RootNavigationController: UINavigationController {

    init() {
        super.init(nibName: nil, bundle: nil)
        let homeViewController = HomeViewController()
        pushViewController(homeViewController, animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
}
