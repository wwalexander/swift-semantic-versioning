import Testing
@testable import SemanticVersioning
import Parsing

let normalIncreasingExamples = [
    ("1.9.0", Version(1, 9, 0)),
    ("1.10.0", Version(1, 10, 0)),
    ("1.11.0", Version(1, 11, 0)),
]


let publicExamples = [
    ("1.0.0", Version(1, 0, 0)),
]

let prereleaseExamples = [
    ("1.0.0-alpha", Version(1, 0, 0, prereleaseIdentifiers: ["alpha"])),
    ("1.0.0-alpha.1", Version(1, 0, 0, prereleaseIdentifiers: ["alpha", "1"])),
    ("1.0.0-0.3.7", Version(1, 0, 0, prereleaseIdentifiers: ["0", "3", "7"])),
    ("1.0.0-x.7.z.92", Version(1, 0, 0, prereleaseIdentifiers: ["x", "7", "z", "92"])),
    ("1.0.0-x-y-z.--", Version(1, 0, 0, prereleaseIdentifiers: ["x-y-z", "--"]))
]

let buildExamples = [
    ("1.0.0-alpha+001", Version(1, 0, 0, prereleaseIdentifiers: ["alpha"], buildMetadataIdentifiers: ["001"])),
    ("1.0.0+20130313144700", Version(1, 0, 0, buildMetadataIdentifiers: ["20130313144700"])),
    ("1.0.0-beta+exp.sha.5114f85", Version(1, 0, 0, prereleaseIdentifiers: ["beta"], buildMetadataIdentifiers: ["exp", "sha", "5114f85"])),
    ("1.0.0+21AF26D3----117B344092BD", Version(1, 0, 0, buildMetadataIdentifiers: ["21AF26D3----117B344092BD"])),
]

let normalPrecedenceExamples = [
    ("1.0.0", Version(1, 0, 0)),
    ("2.0.0", Version(2, 0, 0)),
    ("2.1.0", Version(2, 1, 0)),
    ("2.1.1", Version(2, 1, 1)),
]


let prereleaseNormalPrecedenceExamples = [
    ("1.0.0-alpha", Version(1, 0, 0, prereleaseIdentifiers: ["alpha"])),
    ("1.0.0", Version(1, 0, 0)),
]

let prereleasePrecedenceExamples = [
    ("1.0.0-alpha", Version(1, 0, 0, prereleaseIdentifiers: ["alpha"])),
    ("1.0.0-alpha.1", Version(1, 0, 0, prereleaseIdentifiers: ["alpha.1"])),
    ("1.0.0-alpha.beta", Version(1, 0, 0, prereleaseIdentifiers: ["alpha.beta"])),
    ("1.0.0-beta", Version(1, 0, 0, prereleaseIdentifiers: ["beta"])),
    ("1.0.0-beta.2", Version(1, 0, 0, prereleaseIdentifiers: ["beta.2"])),
    ("1.0.0-beta.11", Version(1, 0, 0, prereleaseIdentifiers: ["beta.11"])),
    ("1.0.0-rc.1", Version(1, 0, 0, prereleaseIdentifiers: ["rc.1"])),
    ("1.0.0", Version(1, 0, 0))
]

let allExamples = Dictionary([
    normalIncreasingExamples,
    publicExamples,
    prereleaseExamples,
    buildExamples,
    normalPrecedenceExamples,
    prereleaseNormalPrecedenceExamples,
    prereleaseExamples,
].flatMap { $0 }) { lhs, rhs in lhs }

@Test(arguments: allExamples)
func testParser(input: String, output: Version) throws {
    let parser = Version.parser()
    try #expect(parser.parse(input) == output)
    try #expect(parser.print(output) == input)
}

@Test(arguments: allExamples)
func testCustomStringConvertible(input: String, output: Version) throws {
    #expect(String(describing: output) == input)
}

@Test(arguments: allExamples)
func testLosslessStringConvertible(input: String, output: Version) throws {
    #expect(Version(input) == output)
}

@Test(arguments: [normalIncreasingExamples, normalPrecedenceExamples])
func testComparable(sortedExamples: [(String, Version)]) throws {
    for (lhs, rhs) in zip(sortedExamples, sortedExamples.dropFirst()) {
        #expect(lhs.1 < rhs.1)
    }
}

