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
        .library(name: "ThreeDS_SDK", targets: ["ThreeDS_SDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/netceteragroup/ios-3ds-sdk-spm.git", exact: "2.6.1")
    ],
    targets: [
        .binaryTarget(name: "ReactBrownfield", path: "./ReactBrownfield.xcframework"),
        .binaryTarget(name: "TwintSDK", path: "./TwintSDK.xcframework"),
        .binaryTarget(name: "WalleePaymentSdk", path: "./WalleePaymentSdk.xcframework"),
        .binaryTarget(name: "hermes", path: "./hermes.xcframework"),
        .target(name: "ThreeDS_SDK", dependencies: [
            .product(name: "ThreeDS_SDK", package: "ios-3ds-sdk-spm")
        ])
    ]
)
