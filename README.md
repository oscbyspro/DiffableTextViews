# DiffableTextViews

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

This package contains views and styles that use snapshots and attributes to process changes to text and set caret positions. This approach makes it easy to implement and reason about as-you-type formatting.

# Progress

🔵🔵🔵🔵🔵⚪️⚪️⚪️⚪️⚪️

# Views

## DiffableTextField

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

# Styles

## NumericTextStyle ([Values](../main/Notes/NumericTextStyles/VALUES.md))

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
            textField.font(.body.monospaced())
        }    
    }
}
```

## PatternTextStyle

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
            .predicate(.value({ $0.allSatisfy(\.isNumber) }))
            .predicate(.character(\.isASCII))
        }
        .setup { 
            textField in
            textField.keyboard(.phonePad)
            textField.font(.body.monospaced())
        }
    }
}
```
