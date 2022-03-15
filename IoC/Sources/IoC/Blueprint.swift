
// MARK: - Blueprint

struct Blueprint {
    let factory: () throws -> Any
    let afterInit: ((Container, Any) throws -> Void)?
}

// MARK: - Blueprint Tag

enum BlueprintTag: Equatable {

    case string(String)

    init?(_ string: String?) {
        switch string {
        case .none: return nil
        case .some(let string): self = .string(string)
        }
    }
}

// MARK: - Blueprint Key

struct BlueprintKey: Hashable {

    let type: Any.Type
    let tag: BlueprintTag?

    func hash(into hasher: inout Hasher) {
        hasher.combine(tag.description)
        hasher.combine(ObjectIdentifier(type))
    }

    static func == (lhs: BlueprintKey, rhs: BlueprintKey) -> Bool {
        return lhs.type == rhs.type && lhs.tag == rhs.tag
    }
}
