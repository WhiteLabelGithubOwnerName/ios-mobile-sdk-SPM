// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WalleePaymentSdk",
    platforms: [.iOS("15.1")],
    products: [
        .library(
            name: "WalleePaymentSdk",
            targets: ["WalleePaymentSdk", "ReactBrownfield", "ThreeDS_SDK", "TwintSDK", "hermes"]
        ),
        // kept for backward compatibility
        .library(name: "ReactBrownfield", targets: ["ReactBrownfield"]),
        .library(name: "ThreeDS_SDK", targets: ["ThreeDS_SDK"]),
        .library(name: "TwintSDK", targets: ["TwintSDK"]),
        .library(name: "hermes", targets: ["hermes"])
    ],
    targets: [
        .binaryTarget(name: "ReactBrownfield", path: "./ReactBrownfield.xcframework"),
        .binaryTarget(name: "ThreeDS_SDK", path: "./ThreeDS_SDK.xcframework"),
        .binaryTarget(name: "TwintSDK", path: "./TwintSDK.xcframework"),
        .binaryTarget(name: "WalleePaymentSdk", path: "./WalleePaymentSdk.xcframework"),
        .binaryTarget(name: "hermes", path: "./hermes.xcframework")
    ]
)
