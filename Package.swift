// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SubtitleKit",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "SubtitleKit",
            targets: ["SubtitleKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Parser"
        ),
        .target(
            name: "SubtitleKit",
            dependencies: ["Parser"]),
        .testTarget(
            name: "SubtitleKitTests",
            dependencies: ["SubtitleKit"]),
    ]
)
