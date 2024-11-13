extension Version: CustomStringConvertible {
    public var description: String {
        var description = "\(major).\(minor).\(patch)"

        if !prereleaseIdentifiers.isEmpty {
            description += "-\(prereleaseIdentifiers.joined(separator: "."))"
        }

        if !buildMetadataIdentifiers.isEmpty {
            description += "+\(buildMetadataIdentifiers.joined(separator: "."))"
        }

        return description
    }
}
