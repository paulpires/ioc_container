final class RecursiveCounter {

    private var depth: Int = 0

    func enter<T>(block: () -> T, baseReached: () -> Void) -> T {
        depth = depth + 1
        defer {
            depth = depth - 1
            if depth == 0 {
                baseReached()
            }
        }
        return block()
    }
}
