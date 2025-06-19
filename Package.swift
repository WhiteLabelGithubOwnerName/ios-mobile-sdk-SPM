// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WalleePaymentSdk",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "WalleePaymentSdk",
                 targets: ["WalleePaymentSdk","TwintSDK","PaymentResources","ThreeDS_SDK"]),
    ],
    targets: [
		.binaryTarget(name: "WalleePaymentSdk", path: "WalleePaymentSdk.xcframework"),
		.binaryTarget(name: "TwintSDK", path: "TwintSDK.xcframework"),
		.binaryTarget(
			name: "ThreeDS_SDK",
			url: "https://merchant-plug-in.extranet.netcetera.biz/nca-348-1/readonly-dav/3dssdk-release/ios/release/2.5.22/ThreeDS_SDK.zip",
			checksum: "8ed06e2a903cd04c98fb450a2a44788f18aeaa3f8a108ffe795b9526e34248e6"
		),
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