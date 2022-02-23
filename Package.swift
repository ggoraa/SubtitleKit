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
            name: "Backend"
        ),
        .target(
            name: "SubtitleKit",
            dependencies: ["Backend"]),
        .testTarget(
            name: "SubtitleKitTests",
            dependencies: ["SubtitleKit"]),
    ]
)
