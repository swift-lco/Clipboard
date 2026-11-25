// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Clipboard",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Clipboard",
            targets: ["Clipboard"]
        ),
        .executable(
            name: "clipboard",
            targets: [
                "ClipboardCLI",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-lco/Arguments.git",
            branch: "master"
        ),
    ],

    targets: [
        .target(
            name: "Clipboard"
        ),
        .executableTarget(
            name: "ClipboardCLI",
            dependencies: [
                "Clipboard",
                .product(
                    name: "Arguments",
                    package: "Arguments"
                ),
            ]
        ),
    ]
)
