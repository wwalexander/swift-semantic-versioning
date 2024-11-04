extension Version: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let version = try? Self.parser().parse(description) else {
            return nil
        }

        self = version
    }
}
