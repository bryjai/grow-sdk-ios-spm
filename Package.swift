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
        .binaryTarget(name: "GrowSDK", url: "https://s3-eu-west-1.amazonaws.com/bryj-sdks/ios/1.2.0/Grow-SDK-iOS-1.2.0.xcframework.zip", checksum: "d5a45602050b35f2e7ebcd6ac4fda3b5e7ae287661824c21e4fc9df6dd48f0c4")
    ]
)
