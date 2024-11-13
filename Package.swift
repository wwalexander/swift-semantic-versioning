// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-semantic-versioning",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "SemanticVersioning",
            targets: ["SemanticVersioning"]
        ),
    ],
    targets: [
        .target(name: "SemanticVersioning"),
        .testTarget(
            name: "SemanticVersioningTests",
            dependencies: ["SemanticVersioning"]
        ),
    ]
)
