# API Reference

| API | Type | Description |
| --- | --- | --- |
| `PaymentSdk.shared` | singleton | Shared instance of the SDK used for configuration and launching payments. |
| `PaymentSdk.SDK_VERSION` | property | Current SDK version string. |
| `protocol PaymentResultObserver` | protocol | Protocol for handling post-payment events (`paymentResult`). |
| `func paymentResult(paymentResultMessage: PaymentResult)` | function | Callback invoked when transaction state changes or payment is completed. |
| `func initialize()` | function | Initializes the SDK runtime and prepares the React Native environment. Must be called before launching payment. |
| `func resultObserver(eventObserver: PaymentResultObserver)` | function | Registers a result observer. Must be configured before launching payment. |
| `func launchPayment(token: String, paymentMethodConfigurationId: Int? = nil)` | function | Opens the payment flow using UIKit. `paymentMethodConfigurationId` is optional and can be used to preselect a payment method. |
| `func launchPayment(token: String, isSwiftUI: Bool, paymentMethodConfigurationId: Int? = nil)` | function | Opens the payment flow in SwiftUI applications. Available on **iOS 13.0+**. |
| `static func onHandleOpenURL(url: URL) -> Bool` | function | Handles incoming deep links / callbacks (for example TWINT). Must be called in `SceneDelegate` or `AppDelegate` URL handling methods. Returns `true` if handled by SDK. |
| `func configureApplePay(merchantId: String)` | function | Configures Apple Pay Merchant ID used for Apple Pay transactions. Additional portal configuration may be required. |
| `func configureDeepLink(deepLink: String)` | function | Configures application deep link used to return users back to the host app after payment completion. |
| `func setLightTheme(light: NSMutableDictionary)` | function | Overrides or extends the default light theme colors. |
| `func setDarkTheme(dark: NSMutableDictionary)` | function | Overrides or extends the default dark theme colors. |
| `func setCustomTheme(custom: NSMutableDictionary?, baseTheme: ThemeEnum)` | function | Forces a custom theme regardless of system appearance. Can override all or selected colors based on a base theme. |
| `func setAnimation(type: AnimationEnum)` | function | Sets transition animation style used inside the payment flow. |
| `func close()` | function | Removes registered observers and performs SDK cleanup. |
