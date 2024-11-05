extension Version: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        for keyPath in [\Self.major, \Self.minor, \Self.patch] {
            let lhs = lhs[keyPath: keyPath]
            let rhs = rhs[keyPath: keyPath]

            if lhs != rhs {
                return lhs < rhs
            }
        }

        let lhs = lhs.prereleaseIdentifiers
        let rhs = rhs.prereleaseIdentifiers

        switch (lhs.count, rhs.count) {
        case (0, 0...): return false
        case (1..., 0): return true
        default: break
        }

        for (lhs, rhs) in zip(lhs, rhs) {
            switch (UInt(lhs), UInt(rhs)) {
            case (.none, .none):
                if lhs != rhs {
                    return lhs < rhs
                }
            case let (.some(lhs), .some(rhs)):
                if lhs != rhs {
                    return lhs < rhs
                }
            case (.some, .none):
                return true
            case (.none, .some):
                return false
            }
        }

        return lhs.count < rhs.count
    }
}
