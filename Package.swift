// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WalleePaymentSdk",
    platforms: [.iOS("15.1")],
    products: [
        .library(
            name: "WalleePaymentSdk",
            targets: ["WalleePaymentSdk", "ThreeDS_SDK", "hermes"]
        )
    ],
    targets: [
        .binaryTarget(name: "ThreeDS_SDK", path: "./ThreeDS_SDK.xcframework"),
        .binaryTarget(name: "WalleePaymentSdk", path: "./WalleePaymentSdk.xcframework"),
        .binaryTarget(name: "hermes", path: "./hermes.xcframework")
    ]
)
