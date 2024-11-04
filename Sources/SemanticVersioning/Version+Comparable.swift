extension Version: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case
            let (lhs, rhs) where lhs.major < rhs.major,
            let (lhs, rhs) where lhs.minor < rhs.minor,
            let (lhs, rhs) where lhs.patch < rhs.patch: true
        default:
            switch (lhs.prereleaseIdentifiers, rhs.prereleaseIdentifiers) {
            case let (lhs, rhs) where lhs.count < rhs.count: true
            case let (lhs, rhs) where lhs.count == rhs.count:
                zip(lhs, rhs).contains { lhs, rhs in
                    switch (Int(lhs), Int(rhs)) {
                    case (.some, .none): true
                    case let (.some(lhs), .some(rhs)): lhs < rhs
                    case (.none, .none): lhs < rhs
                    default: false
                    }
                }
            default: false
            }
        }
    }
}
