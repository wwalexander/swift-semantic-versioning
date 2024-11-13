import RegexBuilder

extension Version: LosslessStringConvertible {
    public init?(_ description: String) {
        let letter = "A"..."z"
        let positiveDigit = "1"..."9"
        let digit = "0"..."9"
        let nonDigit = letter.union(.anyOf("-"))
        let identifierCharacter = digit.union(nonDigit)

        let numericIdentifier = ChoiceOf {
            "0"
            Regex {
                positiveDigit
                ZeroOrMore(digit)
            }
        }

        let alphanumericIdentifier = Regex {
            ZeroOrMore(identifierCharacter)
            nonDigit
            ZeroOrMore(identifierCharacter)
        }

        let buildIdentifier = ChoiceOf {
            OneOrMore(digit)
            alphanumericIdentifier
        }

        let prereleaseIdentifier = ChoiceOf {
            numericIdentifier
            alphanumericIdentifier
        }

        let dotSeparatedPrereleaseIdentifiers = Regex {
            prereleaseIdentifier
            ZeroOrMore {
                "."
                prereleaseIdentifier
            }
        }

        let dotSeparatedBuildIdentifiers = Regex {
            buildIdentifier
            ZeroOrMore {
                "."
                buildIdentifier
            }
        }

        let build = Capture(dotSeparatedBuildIdentifiers) {
            $0.split(separator: ".").map(String.init)
        }

        let prerelease = Capture(dotSeparatedPrereleaseIdentifiers) {
            $0.split(separator: ".").map(String.init)
        }

        let major = TryCapture(numericIdentifier) {
            Int(String($0))
        }

        let minor = TryCapture(numericIdentifier) {
            Int(String($0))
        }

        let patch = TryCapture(numericIdentifier) {
            Int(String($0))
        }

        let versionCore = Regex {
            major
            "."
            minor
            "."
            patch
        }

        let validSemver = Regex {
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

        guard let match = description.wholeMatch(of: validSemver) else {
            return nil
        }

        self.init(
            match.output.1,
            match.output.2,
            match.output.3,
            prereleaseIdentifiers: match.output.4 ?? [],
            buildMetadataIdentifiers: match.output.5 ?? []
        )
    }
}
