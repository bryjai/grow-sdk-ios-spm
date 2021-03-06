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
        .binaryTarget(name: "GrowSDK", url: "https://s3-eu-west-1.amazonaws.com/bryj-sdks/ios/1.0.2/Grow-SDK-iOS-1.0.2.xcframework.zip", checksum: "146b2b513f8c540df9413ff43fa1730dabe242b8c0636d3f0812d67dfcc8c34e")
    ]
)
