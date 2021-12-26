# DiffableTextViews

This package contains views that use snapshots and attributes to process a user's text input, detect changes and set caret positions. This makes it easy to implement as-you-type formatting. Such implementations are made by styles conforming to: DiffableTextStyle.

# Progress

🔵🔵🔵⚪️⚪️⚪️⚪️⚪️⚪️⚪️

# Views
### DiffableTextField

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
            .numeric.locale(locale).suffix(locale.currencyCode)
            .bounds(.values(in: 0...1_000_000 as ClosedRange<Decimal>))
            .precision(.digits(integer: 1..., fraction: 2...2))
        }
        .setup { 
            textField in 
            textField.keyboard(.decimalPad) 
            textField.font(.system.monospaced())
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
        }
        .setup { 
            textField in
            textField.keyboard(.phonePad)
            textField.font(.system.monospaced())
        }
    }
}
```
