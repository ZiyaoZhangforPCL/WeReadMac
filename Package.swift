// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WeReadMac",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "WeReadMac", targets: ["WeReadMac"])
    ],
    targets: [
        .executableTarget(
            name: "WeReadMac",
            path: "Sources/WeReadMac"
        )
    ]
)
