import Testing
@testable import SemanticVersioning
import Parsing

@Test(arguments: [
    "1.9.0": Version(1, 9, 0),
    "1.10.0": Version(1, 10, 0),
    "1.11.0": Version(1, 11, 0),
    "1.0.0": Version(1, 0, 0),
    "1.0.0-alpha": Version(1, 0, 0, prereleaseIdentifiers: ["alpha"]),
    "1.0.0-alpha.1": Version(1, 0, 0, prereleaseIdentifiers: ["alpha", "1"]),
    "1.0.0-0.3.7": Version(1, 0, 0, prereleaseIdentifiers: ["0", "3", "7"]),
    "1.0.0-x.7.z.92": Version(1, 0, 0, prereleaseIdentifiers: ["x", "7", "z", "92"]),
    "1.0.0-x-y-z.--": Version(1, 0, 0, prereleaseIdentifiers: ["x-y-z", "--"]),
    "1.0.0-alpha+001": Version(1, 0, 0, prereleaseIdentifiers: ["alpha"], buildMetadataIdentifiers: ["001"]),
    "1.0.0+20130313144700": Version(1, 0, 0, buildMetadataIdentifiers: ["20130313144700"]),
    "1.0.0-beta+exp.sha.5114f85": Version(1, 0, 0, prereleaseIdentifiers: ["beta"], buildMetadataIdentifiers: ["exp", "sha", "5114f85"]),
    "1.0.0+21AF26D3----117B344092BD": Version(1, 0, 0, buildMetadataIdentifiers: ["21AF26D3----117B344092BD"]),
    "2.0.0": Version(2, 0, 0),
    "2.1.0": Version(2, 1, 0),
    "2.1.1": Version(2, 1, 1),
    "1.0.0-alpha": Version(1, 0, 0, prereleaseIdentifiers: ["alpha"]),
    "1.0.0-alpha.1": Version(1, 0, 0, prereleaseIdentifiers: ["alpha.1"]),
    "1.0.0-alpha.beta": Version(1, 0, 0, prereleaseIdentifiers: ["alpha.beta"]),
    "1.0.0-beta": Version(1, 0, 0, prereleaseIdentifiers: ["beta"]),
    "1.0.0-beta.2": Version(1, 0, 0, prereleaseIdentifiers: ["beta.2"]),
    "1.0.0-beta.11": Version(1, 0, 0, prereleaseIdentifiers: ["beta.11"]),
    "1.0.0-rc.1": Version(1, 0, 0, prereleaseIdentifiers: ["rc.1"]),
])
func testParser(input: String, output: Version) throws {
    try #expect(Version.parser().parse(input) == output)
}

@Test(arguments: [
    ("1.0.0-0.3.7", "1.0.0-alpha"),
    ("1.0.0-alpha", "1.0.0-alpha.1"),
    ("1.0.0-alpha.1", "1.0.0-alpha.beta"),
    ("1.0.0-alpha.beta", "1.0.0-beta"),
    ("1.0.0-beta", "1.0.0-beta.2"),
    ("1.0.0-beta.2", "1.0.0-beta.11"),
    ("1.0.0-beta.11", "1.0.0-rc.1"),
    ("1.0.0-rc.1", "1.0.0-x.7.z.92"),
    ("1.0.0-x.7.z.92", "1.0.0-x-y-z.--"),
    ("1.0.0-x-y-z.--", "1.0.0"),
    ("1.0.0", "1.9.0"),
    ("1.9.0", "1.10.0"),
    ("1.10.0", "1.11.0"),
    ("1.11.0", "2.0.0"),
    ("2.0.0", "2.1.0"),
    ("2.1.0", "2.1.1"),
] as [(Version, Version)])
func testComparable(lhs: Version, rhs: Version) {
    #expect(lhs < rhs)

}
