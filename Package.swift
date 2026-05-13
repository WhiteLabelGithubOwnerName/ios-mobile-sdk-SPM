// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WalleePaymentSdk",
    platforms: [.iOS("12.4")],
    products: [
        .library(name: "ThreeDS_SDK", targets: ["ThreeDS_SDK"]),
        .library(name: "TwintSDK", targets: ["TwintSDK"])
    ],
    targets: [
        .binaryTarget(name: "ThreeDS_SDK", path: "./ThreeDS_SDK.xcframework"),
        .binaryTarget(name: "TwintSDK", path: "./TwintSDK.xcframework")
    ]
)
