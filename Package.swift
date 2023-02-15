// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GrowSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "GrowSDK",
            targets: ["GrowSDK"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(name: "GrowSDK", url: "https://s3-eu-west-1.amazonaws.com/bryj-sdks/ios/1.1.0/Grow-SDK-iOS-1.1.0.xcframework.zip", checksum: "c3c7d79df528e788859e132fb816e01f78e7e6f629011e8b16dacdc7c87be0da")
    ]
)
