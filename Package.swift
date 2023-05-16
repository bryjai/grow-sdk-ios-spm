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
        .binaryTarget(name: "GrowSDK", url: "https://s3-eu-west-1.amazonaws.com/bryj-sdks/ios/1.1.2/Grow-SDK-iOS-1.1.2.xcframework.zip", checksum: "3dddc292c8d105a603b00fb1a1100608e7f1f0a2e91fa77e9850eec009060ad1")
    ]
)
