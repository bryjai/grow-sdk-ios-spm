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
        .binaryTarget(name: "GrowSDK", url: "https://s3-eu-west-1.amazonaws.com/bryj-sdks/ios/1.2.3/Grow-SDK-iOS-1.2.3.xcframework.zip", checksum: "c8875d73ee071c3aae359c8c91782b8eb5e8c0b5610c0a930a0e5c50ad8f3e55")
    ]
)
