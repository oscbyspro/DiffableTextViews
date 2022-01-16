# DiffableTextViews

A framework for as-you-type formatting of text bound to desired data types.

### Features

|   | Features | Description |
|---|----------|---------|
| :fire: | As-you-type. | Formats text input in real time. |
| :trophy: | Useful and convenient. | Converts to and from non-text types. |
| :running_man: | Fast and efficient. | Uses a O(n) differentiation algorithm. |
| :desktop_computer: | Easy to reason about. | Uses snapshots and attributes. |
| :book: | Versatile. | Supports left-to-right, right-to-left, emojis. |

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
| :art: | Formats | Number, Currency and Percent. |
| :national_park: | Locales | All available in the Foundation framework. |

### Examples

```swift
import SwiftUI
import DiffableTextViews
import NumericTextStyles

struct NumericTextStyleExample: View {
    @State var amount: Decimal = 0
    
    let currencyCode = "USD"
    let locale = Locale(identifier: "en_SE")
    
    var body: some View {
        DiffableTextField($amount) {
            .currency(code: currencyCode).locale(locale)
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
