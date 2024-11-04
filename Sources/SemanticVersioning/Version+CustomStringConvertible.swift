extension Version: CustomStringConvertible {
    public var description: String {
        try! String(Self.parser().print(self))
    }
}
