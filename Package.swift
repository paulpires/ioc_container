// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "IoC",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "IoC", targets: ["IoC"])
    ],
    dependencies: [],
    targets: [
        .target(name: "IoC", dependencies: []),
        .testTarget(name: "IoCTests", dependencies: ["IoC"])
    ]
)
