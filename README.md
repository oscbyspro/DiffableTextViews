# DiffableTextViews

A framework for as-you-type formatting of text bound to its appropriate data type.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :keyboard: | As-you-type. | Formats and parses text in real time. |
| :hammer_and_wrench: | Versatile. | Uses snapshots and attributes. |
| :running_man: | Fast. | Uses an O(n) differentiation algorithm. |
| :magic_wand: | Automagical. | Binds text to its appropriate data type. |

# Progress

🔵🔵🔵🔵🔵🔵🔵🔵🔵⚪️

# Views

## DiffableTextField

👷‍♂️🛠🚧🚧🧱🏗🧱🚧🚧⏳

|   | Feature | Description |
|---|---------|-------------|
| :iphone: | SwiftUI | Value, style, done. |
| :balance_scale: | Monospaced | Standard font is monospaced. |
| :sewing_needle: | Customizable | Styles may provide default values. |
| :evergreen_tree: | Environment | Locales are set by the environment. |

### Customization

```swift
extension NumericTextStyle: UIKitDiffableTextStyle {    
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
| :coin: | [Values](../main/Notes/NumericTextStyles/VALUES.md) | Decimal, Float(16-64) and (U)Int(8-64). |
| :bow_and_arrow: | Precision | Up to 38 significant digits. |
| :bricks: | Bounds | Clamps input and output to specified range. |
| :art: | Formats | Number, currency and percent. |
| :national_park: | Locales | Every locale in the Foundation framework. |
| :book: | Bilingual | Accepts both local and system characters. |

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
            .bounds(.values((0 as Decimal)...))
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
