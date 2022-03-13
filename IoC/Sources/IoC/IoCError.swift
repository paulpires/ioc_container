public enum IoCError: Error, CustomStringConvertible {

    case missingRegistration(type: Any.Type)

    public var description: String {
        switch self {
        case .missingRegistration(let type):
            return "Missing container registration for type: \(String(reflecting: type))."
        }
    }
}
