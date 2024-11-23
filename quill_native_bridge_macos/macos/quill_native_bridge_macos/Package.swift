// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "quill_native_bridge_macos",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "quill-native-bridge-macos", targets: ["quill_native_bridge_macos"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "quill_native_bridge_macos",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        )
    ]
)