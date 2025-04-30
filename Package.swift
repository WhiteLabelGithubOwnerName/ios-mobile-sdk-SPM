// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WalleePaymentSdk",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "WalleePaymentSdk",
                 targets: ["ThreeDS_SDK","WalleePaymentSdk","TwintSDK"]),
    ],
    targets: [
		.binaryTarget(name: "ThreeDS_SDK",
									 path:  "ThreeDS_SDK.xcframework"),
		.binaryTarget(name: "WalleePaymentSdk",
									 path:  "WalleePaymentSdk.xcframework"),
		.binaryTarget(name: "TwintSDK",
									 path:  "TwintSDK.xcframework"),

    ]
)