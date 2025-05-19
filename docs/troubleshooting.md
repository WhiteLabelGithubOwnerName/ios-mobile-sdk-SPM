## Troubleshooting

Issue (or similar message):

```gradle
 Failed to build module 'PaymentSdk'; this SDK is not supported by the compiler (the SDK is built with 'Apple Swift version 5.10 (swiftlang-5.10.0.13 clang-1500.3.9.4)', while this compiler is 'Apple Swift version 6.0.3 effective-5.10 (swiftlang-6.0.3.1.10 clang-1600.0.30.1)'). Please select a toolchain which matches the SDK.

```

Recommendation: To ensure proper SDK functionality, we recommend using Swift 5.10 or a compatible version, especially when integrating into Xcode 15.4 or earlier. For newer versions of Xcode (e.g., 15.5 and above), consider using updated SDK versions available through CocoaPods.
