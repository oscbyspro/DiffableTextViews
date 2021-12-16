# DiffableTextViews

This package contains views that use snapshots and attributes to process a user's text input, detect changes and set caret positions. This makes it possible (and even easy) to implement as-you-type formatting. Such implementations are made through styles conforming to the protocol: DiffableTextStyle.

# Progress

🔵🔵🔵⚪️⚪️⚪️⚪️⚪️⚪️⚪️

# Views
### DiffableTextField

# Styles
### NumericTextStyle

# Usage

```swift
import SwiftUI
import DiffableTextViews
import NumericTextStyles

struct Example: View {
    @State var decimal: Decimal = 0
    
    let locale = Locale(identifier: "en_US")
    
    var body: some View {
        DiffableTextField(amount) {
            .numeric.locale(locale).suffix(locale.currencyCode)
            .bounds(.values(in: 0...1_000_000 as ClosedRange<Decimal>))
            .precision(.digits(integer: 1..., decimal: 2...2))
        }
        .setup({ textField in textField.keyboard(.decimalPad) })
    }
}
```
