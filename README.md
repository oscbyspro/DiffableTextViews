# DiffableTextViews

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

This package contains views and styles that use snapshots and attributes to process changes to text and set caret positions. This approach makes it easy to implement and reason about as-you-type formatting.

# Progress

🔵🔵🔵🔵🔵🔵🔵🔵🔵⚪️

# Views

## DiffableTextField

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

- Standard font is monospaced.

# Styles

## NumericTextStyle 

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

### Features

|   | Features | Details |
|---|----------|---------|
| :arrows_counterclockwise: | [Values](../main/Notes/NumericTextStyles/VALUES.md) | Decimal, Float(16-64) and (U)Int(8-64). |
| :straight_ruler: | Bounds | Clamps input and output to specified range. |
| :mag_right: | Precision | Up to 38 significant digits. |
| :paintbrush: | Formats | Number, Currency and Percent. |
| :national_park: | Locales | All available in the Foundation framework. |

### Examples

```swift
import SwiftUI
import DiffableTextViews
import NumericTextStyles

struct NumericTextStyleExample: View {
    @State var amount: Decimal = 0
    
    let locale = Locale(identifier: "en_US")
    
    var body: some View {
        DiffableTextField($amount) {
            .currency(code: locale.currencyCode!).locale(locale)
            .bounds(.values((0 as Decimal)...(1_000_000 as Decimal)))
            .precision(.digits(integer: 1..., fraction: 2))
        }
    }
}
```

## PatternTextStyle

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

### Examples

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
        .setup { textField in textField.keyboard(.phonePad) }
    }
}
```
