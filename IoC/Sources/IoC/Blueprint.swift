
// MARK: - Blueprint

struct Blueprint {
    let factory: () -> Any
}

// MARK: - Blueprint Tag

extension Blueprint {

    enum Tag: Equatable {

        case string(String)

        init?(_ string: String?) {
            switch string {
            case .none: return nil
            case .some(let string): self = .string(string)
            }
        }
    }
}

// MARK: - Blueprint Key

extension Blueprint {

    struct Key: Hashable {

        let type: Any.Type
        let tag: Blueprint.Tag?

        func hash(into hasher: inout Hasher) {
            hasher.combine(tag.description)
            hasher.combine(ObjectIdentifier(type))
        }

        static func == (lhs: Blueprint.Key, rhs: Blueprint.Key) -> Bool {
            return lhs.type == rhs.type && lhs.tag == rhs.tag
        }
    }
}
