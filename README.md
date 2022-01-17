# DiffableTextViews

A framework for as-you-type formatting of text bound to its appropriate data type.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :keyboard: | As-you-type. | Formats and parses text in real time. |
| :hammer_and_wrench: | Versatile. | Uses snapshots and attributes. |
| :running_man: | Fast. | Uses an O(n) differentiation algorithm. |
| :magic_wand: | Automagical. | Binds text to its approptiate data type. |

# Progress

🔵🔵🔵🔵🔵🔵🔵🔵🔵⚪️

# Views

## DiffableTextField

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

### Features

|   | Feature | Description |
|---|---------|-------------|
| :balance_scale: | Font | Standard font is monospaced. |
| :sewing_needle: | Custom | Styles may provide default values. |

### Examples

```swift
extension NumericTextStyle: UIKitTextStyle {    
    static func setup(diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}
```

# Styles

## NumericTextStyle 

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

### Features

|   | Feature | Description |
|---|---------|-------------|
| :arrows_counterclockwise: | [Values](../main/Notes/NumericTextStyles/VALUES.md) | Decimal, Float(16-64) and (U)Int(8-64). |
| :bow_and_arrow: | Precision | Up to 38 significant digits. |
| :bricks: | Bounds | Clamps input and output to specified range. |
| :art: | Formats | Number, currency and percent. |
| :national_park: | Locales | Every locale in the Foundation framework. |

### Examples

```swift
import SwiftUI
import DiffableTextViews
import NumericTextStyles

struct NumericTextStyleExample: View {
    @State var amount: Decimal = 0
    
    let currencyCode = "SEK"
    let locale = Locale(identifier: "en_SE")
    
    var body: some View {
        DiffableTextField($amount) {
            .currency(code: currencyCode)
            .bounds(.values((0 as Decimal)...(1_000_000 as Decimal)))
            .precision(.digits(integer: 1..., fraction: 2))
        }
        .environment(\.locale, locale)
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
        .setup({ textField in textField.keyboard(.phonePad) })
    }
}
```
