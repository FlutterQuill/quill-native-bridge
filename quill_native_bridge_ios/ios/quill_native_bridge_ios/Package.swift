// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "quill_native_bridge_ios",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "quill-native-bridge-ios", targets: ["quill_native_bridge_ios"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "quill_native_bridge_ios",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]
        )
    ]
)