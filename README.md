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
            .precision(.digits(integer: 1..., fraction: 2...2))
            .bounds(.values(in: 0...1_000_000 as ClosedRange<Decimal>))
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
            .filter({ character in character.isASCII && character.isNumber })
        }
        .setup { 
            textField in
            textField.keyboard(.phonePad)
            textField.font(.body.monospaced())
        }
    }
}
```
