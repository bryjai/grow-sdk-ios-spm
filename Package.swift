// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GrowSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "GrowSDK",
            targets: ["GrowSDK"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(name: "GrowSDK", url: "https://s3-eu-west-1.amazonaws.com/bryj-sdks/ios/1.2.4/Grow-SDK-iOS-1.2.4.xcframework.zip", checksum: "35b7443a9a387d8b76f2f3015790927be2303129a7891db324ee4e7b64f90a05")
    ]
)
