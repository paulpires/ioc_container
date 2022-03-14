import UIKit
import IoC

class HomeViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!

    private let foo: FooService
    private let bar: BarService
    private let fooBar: FooBarService

    init(container: Container) {
        foo = try! container.resolve()
        bar = try! container.resolve()
        fooBar = try! container.resolve()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = "\(foo.giveMeFoo()) from \(foo) ref: \(ObjectIdentifier(foo))"
        label2.text = "\(bar.giveMeBar()) from \(bar) ref: \(ObjectIdentifier(bar))"
        label3.text = """
            \(fooBar.giveMeFooBar()) from \(fooBar) ref: \(ObjectIdentifier(fooBar))
            fooBar.foo ref: \(ObjectIdentifier(fooBar.foo))
            fooBar.bar ref: \(ObjectIdentifier(fooBar.bar))
        """
    }
}
