// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WalleePaymentSdk",
    platforms: [.iOS("12.4")],
    products: [
        .library(name: "WalleePaymentSdk",
                 targets: ["ThreeDS_SDK","WalleePaymentSdk","TwintSDK","PaymentResources"]),
    ],
    targets: [
		.binaryTarget(name: "ThreeDS_SDK", path: "ThreeDS_SDK.xcframework"),
		.binaryTarget(name: "WalleePaymentSdk", path: "WalleePaymentSdk.xcframework"),
		.binaryTarget(name: "TwintSDK", path: "TwintSDK.xcframework"),
	.target(
		name: "PaymentResources",
		dependencies: [
			.target(name: "WalleePaymentSdk")
		],
		path: "Sources/PaymentResources",
		sources: ["PaymentResources.swift"],
		resources: [
			.process("walleepaymentsdkbundle.jsbundle")
		]
	)
    ]
)