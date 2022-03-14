// only stores transient objects for now
final class ResolvedInstances {

    private var resolvedInstances = [BlueprintKey: Any]()

    func empty() {
        resolvedInstances.removeAll()
    }

    subscript<T>(key: BlueprintKey) -> T? {
        get {
            return resolvedInstances[key] as? T
        }
        set {
            resolvedInstances[key] = newValue
        }
    }
}
