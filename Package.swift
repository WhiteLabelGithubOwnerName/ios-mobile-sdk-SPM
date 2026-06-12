// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WalleePaymentSdk",
    platforms: [.iOS("12.4")],
    products: [
        .library(name: "ReactBrownfield", targets: ["ReactBrownfield"]),
        .library(name: "TwintSDK", targets: ["TwintSDK"]),
        .library(name: "WalleePaymentSdk", targets: ["WalleePaymentSdk"]),
        .library(name: "hermes", targets: ["hermes"])
    ],
    dependencies: [
        .package(url: "https://github.com/netceteragroup/ios-3ds-sdk-spm.git", exact: "2.6.1")
    ],
    targets: [
        .binaryTarget(name: "ReactBrownfield", path: "./ReactBrownfield.xcframework"),
        .binaryTarget(name: "TwintSDK", path: "./TwintSDK.xcframework"),
        .binaryTarget(name: "hermes", path: "./hermes.xcframework"),
        .binaryTarget(name: "WalleePaymentSdkBinary", path: "./WalleePaymentSdk.xcframework"),
        .target(
            name: "WalleePaymentSdk",
            dependencies: [
                .target(name: "WalleePaymentSdkBinary"),
                .product(name: "ThreeDS_SDK", package: "ios-3ds-sdk-spm")
            ],
            path: "Sources/WalleePaymentSdk"
        )
    ]
)