# Integration

- [Integration](#integration)
  - [Set up](#set-up)
  - [Create transaction](#create-transaction)
  - [Collect payment details](#collect-payment-details)
    - [Basic usage Swift (Storyboard)](#basic-usage-swift-storyboard)
    - [Basic usage SwiftUI](#basic-usage-swiftui)
  - [Handle result](#handle-result)
    - [Result codes](#result-codes)
  - [Additional integration steps](#additional-integration-steps)
    - [Handle deep links](#handle-deep-links)
    - [Configure deep link](#configure-deep-link)
  - [Verify payment](#verify-payment)

## Set up

To use the iOS Payment SDK, you need a [account](https://app-wallee.com/user/signup). After signing up, set up your space and enable the payment methods you would like to support.

## Create transaction

For security reasons, your app cannot create transactions or fetch access tokens directly. This must be done on your server using the [Web Service API](https://app-wallee.com/en-us/doc/api/web-service). You can use one of the official SDK libraries to make these calls.

To collect payments with the iOS Payment SDK, create a backend endpoint that:

1. Creates a transaction
2. Fetches transaction credentials (access token)
3. Returns the token to your iOS app

A transaction contains customer information, purchased items, and tracks payment attempts and state changes.

```bash
# Create a transaction
curl 'https://app-wallee.com/api/transaction/create?spaceId=1' \
  -X "POST" \
  -d "{{TRANSACTION_DATA}}"

# Fetch an access token
curl 'https://app-wallee.com/api/transaction/createTransactionCredentials?spaceId={{SPACE_ID}}&id={{TRANSACTION_ID}}' \
  -X 'POST'
```

The returned access token is then passed to the Payment SDK.

## Collect payment details

### Basic usage Swift (Storyboard)

Before launching the Payment SDK, your checkout page should display:

- purchased products
- total amount
- checkout button

Implement `PaymentResultObserver` to receive payment updates:

```swift
import UIKit
import WalleePaymentSdk

class ViewController: UIViewController, PaymentResultObserver {

    private let paymentSdk = PaymentSdk.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        paymentSdk.initialize(deepLink: "uniq-payment-deep-link")
        paymentSdk.resultObserver(eventObserver: self)
        paymentSdk.configureApplePay(merchantId: "merchant.your.id")
    }

    func paymentResult(paymentResultMessage: PaymentResult) {
        // Handle payment result
    }

    @IBAction func openSdkClick() {
        // Fetch token from backend
        paymentSdk.launchPayment(token: token)
    }
}
```

Once the payment is completed, the SDK closes automatically and calls `paymentResult(...)`.

⚠️ `initialize` and `resultObserver` must be called before `launchPayment`. Otherwise the SDK stops with a fatal error. Passing a `deepLink` is recommended. See [Configure deep link](#configure-deep-link).

---

### Basic usage SwiftUI

For SwiftUI integration, initialize the SDK in a manager class and register the result observer:

```swift
import WalleePaymentSdk

class PaymentManager: PaymentResultObserver {

    private let paymentSdk = PaymentSdk.shared

    init() {
        paymentSdk.initialize(deepLink: "uniq-payment-deep-link")
        paymentSdk.resultObserver(eventObserver: self)
        paymentSdk.configureApplePay(merchantId: "merchant.your.id")
    }

    func paymentResult(paymentResultMessage: PaymentResult) {
        // Handle payment result
    }

    func openPayment(token: String) {
        paymentSdk.launchPayment(
            token: token,
            isSwiftUI: true
        )
    }
}
```

Use it inside your SwiftUI view:

```swift
import SwiftUI

struct ContentView: View {

    private let paymentManager = PaymentManager()

    var body: some View {
        Button("Checkout") {
            // Fetch token from backend first
            paymentManager.openPayment(token: token)
        }
    }
}
```

## Handle result

The SDK returns a `PaymentResult` object containing:

- `code` → payment state
- `message` → localized message for the customer

### Result codes

| Code        | Description                                                                       |
| ----------- | --------------------------------------------------------------------------------- |
| `COMPLETED` | Payment completed successfully.                                                   |
| `FAILED`    | Payment failed. Check `message` for details.                                      |
| `CANCELED`  | Customer canceled the payment.                                                    |
| `PENDING`   | Payment is temporarily pending. Wait for webhook confirmation and verify via API. |
| `TIMEOUT`   | Transaction token expired. A new token must be fetched before reopening the SDK.  |

Example:

```swift
import UIKit
import WalleePaymentSdk

class ViewController: UIViewController, PaymentResultObserver {

    @IBOutlet var resultCallbackText: UILabel?

    func paymentResult(paymentResultMessage: PaymentResult) {
        let colorCodeMap = [
            PaymentResultEnum.FAILED: UIColor.red,
            PaymentResultEnum.COMPLETED: UIColor.green,
            PaymentResultEnum.CANCELED: UIColor.orange
        ]

        DispatchQueue.main.async {
            self.resultCallbackText?.text = paymentResultMessage.code.rawValue
            self.resultCallbackText?.textColor = colorCodeMap[paymentResultMessage.code]
        }
    }
}
```

### Pending timeout

When the customer aborts an external payment step (for example closing a WebView or a third-party app), the transaction is temporarily in a pending state and the SDK returns the `PENDING` result code immediately.

If you prefer to give the backend a short grace period to reach a final status, call `setPendingTimeout` before launching the payment. While waiting, the SDK shows a loading screen and polls the backend for the transaction status every 2 seconds. As soon as a final status arrives it is returned (`COMPLETED` / `FAILED`); if the timeout elapses first, `PENDING` is returned.

The value is given in seconds and is clamped between `2` and `600` seconds (10 minutes).

```swift
PaymentSdk.shared.setPendingTimeout(sec: 30)
PaymentSdk.shared.launchPayment(token: token)
```

## Additional integration steps

### Handle deep links

Your app must forward all incoming URLs back to the SDK. The SDK uses them to receive the payment result when the customer returns from a payment step outside the SDK, for example a bank page opened in the browser or a third-party payment app such as TWINT.

Call:

```swift
PaymentSdk.onHandleOpenURL(url: url)
```

inside your `SceneDelegate` or `AppDelegate`:

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            PaymentSdk.onHandleOpenURL(url: url)
        }
    }
}
```

`onHandleOpenURL` returns `true` when the URL was handled by the SDK, so you can keep handling your own URLs when it returns `false`.

Without this integration, the SDK may not receive the final payment result after returning from the browser or third-party payment apps.

---

### Configure deep link

⚠️ **This step is recommended for all integrations**, regardless of the payment methods you use. Without a deep link, customers may not return to your app after a payment step outside the SDK (for example a bank page opened in the browser or a third-party payment app).

When the payment is finished, the backend redirects to a deep link with the payment result, for example `uniq-payment-deep-link://mobile-sdk-callback/successCallback`.

- If the payment step runs inside the SDK, the SDK handles the deep link directly.
- If the payment step runs outside the SDK, for example on a bank page opened in the browser or in a third-party payment app, that browser or app opens the deep link. iOS then returns the customer to your app, and the SDK receives the payment result through [`onHandleOpenURL`](#handle-deep-links).

You only provide the URL scheme. The deep link URL is built by the backend. Do not build, modify or open it yourself. The SDK does not trust the deep link content. It always fetches the final payment state from the backend, so the deep link only tells the SDK to check the result.

Use a valid URI scheme: lowercase letters, digits, `+`, `-` and `.`, starting with a letter (no underscores). If the scheme is missing or invalid, the backend falls back to the default result URL, and customers may not return to your app after a payment step outside the SDK.

Pass your deep link to `initialize` before launching a payment:

```swift
let paymentSdk = PaymentSdk.shared

paymentSdk.initialize(deepLink: "uniq-payment-deep-link")
paymentSdk.resultObserver(eventObserver: self)
```

The same value must also be configured in your `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>uniq-payment-deep-link</string>
    </array>
  </dict>
</array>
```

The SDK does not check your `Info.plist`. If the scheme is missing there, the payment can launch, but customers cannot return to your app from third-party payment apps.

For TWINT integration, you also need to configure `LSApplicationQueriesSchemes` for TWINT issuer apps:

```xml
 <key>CFBundleURLTypes</key>
 <array>
  <dict>
   <key>CFBundleTypeRole</key>
   <string>Editor</string>
   <key>CFBundleURLSchemes</key>
   <array>
    <string>uniq-payment-deep-link</string>
   </array>
  </dict>
 </array>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>twint-issuer1</string>
    <string>twint-issuer2</string>
    <string>twint-issuer3</string>
    <string>twint-issuer4</string>
    <string>twint-issuer5</string>
    <string>twint-issuer6</string>
    <string>twint-issuer7</string>
    <string>twint-issuer8</string>
    <string>twint-issuer9</string>
    <string>twint-issuer10</string>
    <string>twint-issuer11</string>
    <string>twint-issuer12</string>
    <string>twint-issuer13</string>
    <string>twint-issuer14</string>
    <string>twint-issuer15</string>
    <string>twint-issuer16</string>
    <string>twint-issuer17</string>
    <string>twint-issuer18</string>
    <string>twint-issuer19</string>
    <string>twint-issuer20</string>
    <string>twint-issuer21</string>
    <string>twint-issuer22</string>
    <string>twint-issuer23</string>
    <string>twint-issuer24</string>
    <string>twint-issuer25</string>
    <string>twint-issuer26</string>
    <string>twint-issuer27</string>
    <string>twint-issuer28</string>
    <string>twint-issuer29</string>
    <string>twint-issuer30</string>
    <string>twint-issuer31</string>
    <string>twint-issuer32</string>
    <string>twint-issuer33</string>
    <string>twint-issuer34</string>
    <string>twint-issuer35</string>
    <string>twint-issuer36</string>
    <string>twint-issuer37</string>
    <string>twint-issuer38</string>
    <string>twint-issuer39</string>
    <string>twint-issuer40</string>
    <string>twint-issuer41</string>
    <string>twint-issuer42</string>
    <string>twint-issuer43</string>
    <string>twint-issuer44</string>
    <string>twint-issuer45</string>
    <string>twint-issuer46</string>
    <string>twint-issuer47</string>
    <string>twint-issuer48</string>
    <string>twint-issuer49</string>
    <string>twint-issuer50</string>
</array>

```

## Verify payment

Customers may:

- close the app
- lose internet connection
- interrupt payment flow
- manipulate client responses

Because of that, **you should always verify payment state on your backend**.

The recommended approach is:

1. Listen for webhook events
2. Retrieve transaction state via API
3. Update your backend order state accordingly

More information can be found in the [webhook documentation](https://app-wallee.com/en-us/doc/webhooks).

```

```
