import Parsing

extension Version {
    public static func parser() -> some ParserPrinter<Substring, Self> {
        let numericIdentifier = OneOf(input: Substring.self, output: Int.self) {
            "0".map { 0 }
            Parse {
                Peek {
                    Prefix(1...1, while: \.isPositiveDigit)
                }
                Digits(1...)
            }
        }

        let alphanumericIdentifier = Parse(input: Substring.self) {
            Consumed {
                Prefix(0..., while: \.isDigit)
                Prefix(1...1, while: \.isNonDigit)
                Prefix(0..., while: \.isIdentifierCharacter)
            }
        }

        let prereleaseIdentifier = Parse(input: Substring.self, .string) {
            OneOf {
                alphanumericIdentifier
                Consumed { numericIdentifier }
            }
        }

        let buildIdentifier = Parse(input: Substring.self, .string) {
            OneOf {
                alphanumericIdentifier
                Consumed { Digits(1...) }
            }
        }

        let major = numericIdentifier
        let minor = numericIdentifier
        let patch = numericIdentifier

        let versionCore = Parse {
            major
            "."
            minor
            "."
            patch
        }

        let validSemver = ParsePrint(input: Substring.self, .memberwise(Self.init)) {
            versionCore
            Parse {
                "-"
                Many(1...) {
                    prereleaseIdentifier
                } separator: {
                    "."
                }
            }.replaceError(with: [] as [String])
            Parse {
                "+"
                Many(1...) {
                    buildIdentifier
                } separator: {
                    "."
                }
            }.replaceError(with: [] as [String])

        }

        return validSemver

    }
}

fileprivate extension Character {
    var isDigit: Bool { isWholeNumber }
    var isPositiveDigit: Bool { isDigit && self != "0" }
    var isNonDigit: Bool { isLetter || self == "-" }
    var isIdentifierCharacter: Bool { isDigit || isNonDigit }
}
