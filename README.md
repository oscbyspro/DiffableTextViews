# DiffableTextViews

This package contains views that use snapshots and attributes to process changes and setting caret positions. This makes it comparatively easy to implement as-you-type formatting. Such implementations are made by styles conforming to the protocol: DiffableTextStyle.

# Progress

🔵🔵🔵🔵🔵⚪️⚪️⚪️⚪️⚪️

# Views

### DiffableTextField

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

# Styles

### NumericTextStyle

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

```swift
import SwiftUI
import DiffableTextViews
import NumericTextStyles

struct NumericTextStyleExample: View {
    @State var amount: Decimal = 0
    
    let locale = Locale(identifier: "en_US")
    
    var body: some View {
        DiffableTextField($amount) {
            .numeric
            .locale(locale)
            .suffix(locale.currencyCode)
            .precision(.digits(integer: 1..., fraction: 2))
            .bounds(.values((0 as Decimal)...(1_000_000 as Decimal)))
        }
        .setup { 
            textField in 
            textField.keyboard(.decimalPad) 
            textField.font(.body.monospaced())
        }    
    }
}
```

### PatternTextStyle

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

```swift
import SwiftUI
import DiffableTextViews
import PatternTextStyles

struct PatternTextStyleExample: View {
    @State var phoneNumber: String = ""
    
    var body: some View {
        DiffableTextField($phoneNumber) {
            .pattern("+## (###) ###-##-##", placeholder: "#")
            .filter(\.isASCII)
            .filter(\.isNumber)
        }
        .setup { 
            textField in
            textField.keyboard(.phonePad)
            textField.font(.body.monospaced())
        }
    }
}
```
