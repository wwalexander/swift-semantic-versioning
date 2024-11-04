extension Version: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = try! Self.parser().parse(value)
    }
}
