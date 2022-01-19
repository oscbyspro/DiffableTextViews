# DiffableTextViews

A framework for as-you-type formatting of text bound to its appropriate data type.

### Progress

🔵🔵🔵🔵🔵🔵🔵🔵🔵⚪️

### Features

|   | Feature | Description |
|---|---------|-------------|
| :keyboard: | Responsive. | Formats and parses text as you type. |
| :magic_wand: | Automagical. | Binds text to its appropriate data type. |
| :hammer_and_wrench: | Versatile. | Uses snapshots and attributes. |
| :running_man: | Efficient. | Uses an O(n) differentiation algorithm. |
| :desert_island: | Standalone. | Uses no remote dependencies. |

### Requirements

- iOS 15.0+
- Swift 4.0+

# Views

## [DiffableTextField](../main/Notes/DiffableTextViews/DiffableTextField.md)

|   | Feature | Description |
|---|---------|-------------|
| :iphone: | SwiftUI | Value, style, done. |
| :balance_scale: | Monospaced | Standard font is monospaced. |
| :sewing_needle: | Customizable | Styles may provide default values. |
| :evergreen_tree: | Environment | Locales are set by the environment. |

# Styles

## [NumericTextStyle](../main/Notes/NumericTextStyles/NumericTextStyle.md)

### Features

|   | Feature | Description |
|---|---------|-------------|
| :coin: | Values | Decimal, Float(16-64) and (U)Int(8-64). |
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
            .bounds((0 as Decimal)...)
            .precision(integer: 1..., fraction: 2)
        }
        .environment(\.locale, locale)
    }
}
```

## PatternTextStyle

### Features

|   | Feature | Description |
|---|---------|-------------|
| :checkered_flag: | Pattern. | Characters are laid out as described by a pattern. | 
| :chess_pawn: | Placeholders. | Placeholders represent not-yet-assigned values. |
| :fist_raised: | Independance. | Supports multiple placeholders with different rules. |
| :ghost: | Invisible. | Pattern suffix can easily be \\.hidden(). |
| :feather: | Lightweight. | ~200 lines of code. |


### Examples

```swift
import SwiftUI
import DiffableTextViews
import PatternTextStyles

struct PatternTextStyleExample: View {
    @State var phone: String = ""
    
    var body: some View {
        DiffableTextField($phone) {
            .pattern("+## (###) ###-##-##")
            .placeholder("#") { $0.isASCII && $0.isNumber }
        }
        .setup({ $0.keyboard(.phonePad) })
    }
}

```
