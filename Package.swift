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
        .binaryTarget(name: "GrowSDK", url: "https://s3-eu-west-1.amazonaws.com/bryj-sdks/ios/1.2.2/Grow-SDK-iOS-1.2.2.xcframework.zip", checksum: "5f2b2bb7dd365274fa2c9133b2a8f53071e5a6a5b35ecf569034db97777f7547")
    ]
)
