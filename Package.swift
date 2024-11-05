// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-semantic-versioning",
    platforms: [
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SemanticVersioning",
            targets: ["SemanticVersioning"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-parsing",
            .upToNextMajor(from: "0.13.0")
        ),
    ],
    targets: [
        .target(
            name: "SemanticVersioning",
            dependencies: [
                .product(
                    name: "Parsing",
                    package: "swift-parsing"
                ),
            ]
        ),
        .testTarget(
            name: "SemanticVersioningTests",
            dependencies: ["SemanticVersioning"]
        ),
    ]
)
