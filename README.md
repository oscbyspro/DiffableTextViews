# DiffableTextViews

A framework for as-you-type formatting of text bound to desired data types.

### Features

|   | Features | Description |
|---|----------|-------------|
| :fire: | As-you-type. | Formats text input in real time. |
| :trophy: | Convenient. | Converts to and from non-text types. |
| :running_man: | Fast. | Uses an O(n) differentiation algorithm. |
| :brain: | Smart. | Uses snapshots and attributes. |
| :book: | Versatile. | Supports both directions and emojis. |

# Progress

🔵🔵🔵🔵🔵🔵🔵🔵🔵⚪️

# Views

## DiffableTextField

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

### Features

|   | Features | Description |
|---|----------|-------------|
| :straight_ruler: | Font | Standard font is monospaced. |
| :sewing_needle: | Defaults | Styles can provide default values. |


### Examples

```swift
extension NumericTextStyle: UIKitTextStyle {    
    public func setup(diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}
```

# Styles

## NumericTextStyle 

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

### Features

|   | Features | Description |
|---|----------|-------------|
| :arrows_counterclockwise: | [Values](../main/Notes/NumericTextStyles/VALUES.md) | Decimal, Float(16-64) and (U)Int(8-64). |
| :mag_right: | Precision | Up to 38 significant digits. |
| :straight_ruler: | Bounds | Clamps input and output to specified range. |
| :art: | Formats | Number, currency and percent. |
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
            .predicate(.character(\.isASCII))
            .predicate(.character(\.isNumber))
        }
        .setup { textField in textField.keyboard(.phonePad) }
    }
}
```
