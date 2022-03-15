
/**
 Errors thrown by the `Container`.
 */
public enum IoCError: Error, CustomStringConvertible {

    /**
     Thrown by `resolve(tag:)` if no registration
     block was found for the given type `T` and
     associated tag (if provided)

     - Parameters:
       - type: The type `T` that is missing a registration.
       - tag: Optional tag that was used to uniquely identify this registration.
     */
    case missingRegistration(type: Any.Type)

    /**
     A programmer friendly description of the error.
     */
    public var description: String {
        switch self {
        case .missingRegistration(let type):
            return "Missing container registration for type: \(String(reflecting: type))."
        }
    }
}
