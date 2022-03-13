
extension Optional {
    var description: String {
        switch self {
        case .none:
            return "nil"
        case .some(let wrapped):
            return "\(wrapped)"
        }
    }
}
