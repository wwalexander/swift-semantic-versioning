import RegexBuilder

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

extension Version: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let match = description.wholeMatch(of: Self.validSemver) else {
            return nil
        }

        let (_, major, minor, patch, prereleaseIdentifiers, buildMetadataIdentifiers) = match.output

        self.init(
            major,
            minor,
            patch,
            prereleaseIdentifiers: prereleaseIdentifiers ?? [],
            buildMetadataIdentifiers: buildMetadataIdentifiers ?? []
        )
    }
}

fileprivate extension Version {
    @RegexComponentBuilder
    static var validSemver: Regex<(Substring, Int, Int, Int, [String]?, [String]?)> {
        Anchor.startOfLine
        versionCore
        Optionally {
            "-"
            prerelease
        }
        Optionally {
            "+"
            build
        }
        Anchor.endOfLine
    }

    @RegexComponentBuilder
    static var versionCore: Regex<(Substring, Int, Int, Int)> {
        major
        "."
        minor
        "."
        patch
    }

    static var major: TryCapture<(Substring, Int)> {
        TryCapture(numericIdentifier) { Int(String($0)) }
    }

    static var minor: TryCapture<(Substring, Int)> {
        TryCapture(numericIdentifier) {
            Int(String($0))
        }
    }

    static var patch: TryCapture<(Substring, Int)> {
        TryCapture(numericIdentifier) {
            Int(String($0))
        }
    }

    static var prerelease: Capture<(Substring, [String])> {
        Capture(dotSeparatedPrereleaseIdentifiers) {
            $0.split(separator: ".").map(String.init)
        }
    }

    @RegexComponentBuilder
    static var dotSeparatedPrereleaseIdentifiers: Regex<Substring> {
        prereleaseIdentifier
        ZeroOrMore {
            "."
            prereleaseIdentifier
        }
    }

    static var build: Capture<(Substring, [String])> {
        Capture(dotSeparatedBuildIdentifiers) {
            $0.split(separator: ".").map(String.init)
        }
    }

    @RegexComponentBuilder
    static var dotSeparatedBuildIdentifiers: Regex<Substring> {
        buildIdentifier
        ZeroOrMore {
            "."
            buildIdentifier
        }
    }

    @AlternationBuilder
    static var prereleaseIdentifier: ChoiceOf<Substring> {
        numericIdentifier
        alphanumericIdentifier
    }

    @AlternationBuilder
    static var buildIdentifier: ChoiceOf<Substring> {
        OneOrMore(digit)
        alphanumericIdentifier
    }

    @RegexComponentBuilder
    static var alphanumericIdentifier: Regex<Substring> {
        ZeroOrMore(identifierCharacter)
        nonDigit
        ZeroOrMore(identifierCharacter)
    }

    @AlternationBuilder
    static var numericIdentifier: ChoiceOf<Substring> {
        "0"
        Regex {
            positiveDigit
            ZeroOrMore(digit)
        }
    }

    static var identifierCharacter: CharacterClass { digit.union(nonDigit) }
    static var nonDigit: CharacterClass { letter.union("-"..."-")}
    static var digit: CharacterClass { "0"..."9" }
    static var positiveDigit: CharacterClass { "1"..."9" }
    static var letter: CharacterClass { "A"..."z" }
}
