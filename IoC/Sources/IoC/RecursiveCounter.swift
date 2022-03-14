final class RecursiveCounter {

    private var depth: Int = 0

    func enter<T>(block: () throws -> T, baseReached: () -> Void) rethrows -> T {
        depth = depth + 1
        defer {
            depth = depth - 1
            if depth == 0 {
                baseReached()
            }
        }
        return try block()
    }
}
