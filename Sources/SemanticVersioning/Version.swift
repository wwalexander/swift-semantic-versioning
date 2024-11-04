public struct Version: Sendable {
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let prereleaseIdentifiers: [String]
    public let buildMetadataIdentifiers: [String]

    public init(
        _ major: Int,
        _ minor: Int,
        _ patch: Int,
        prereleaseIdentifiers: [String] = [],
        buildMetadataIdentifiers: [String] = []
    ) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prereleaseIdentifiers = prereleaseIdentifiers
        self.buildMetadataIdentifiers = buildMetadataIdentifiers
    }
}

extension Version: Equatable {}

