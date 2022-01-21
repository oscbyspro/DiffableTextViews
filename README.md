# DiffableTextViews

An open-source package for as-you-type formatting and conversion of text/values.

![DiffableAmountTextField.gif](Assets/DiffableAmountTextField.gif)

![DiffablePhoneNumberTextField.gif](Assets/DiffablePhoneNumberTextField.gif)

### Features

|   | Feature | Description |
|---|---------|-------------|
| :keyboard: | Responsive | Formats and parses text as you type |
| :magic_wand: | Automagical | Binds text to its appropriate data type |
| :hammer_and_wrench: | Versatile | Uses snapshots and attributes |
| :running_man: | Performant | Uses O(n) differentiation algorithms |
| :grey_question: | Agnostic | Supports varied length characters, emojis |
| :desert_island: | Standalone | Has zero remote dependencies |
| :window: | Open-source | Open and transparent, as it should be |

### [Algorithms](Sources/DiffableTextViews/Models/State.swift)

It uses three main algorithms to determine text selection.

|   | Algorithm | Description | Complexity |
|---|-----------|-------------|------------|
| :book: | Text | Determines selection when text changes | ≤ Linear |
| :left_right_arrow: | Positionss | Determine selection by positions/offsets | ≤ Linear |
| :star: | Attributes | Determines selection based on attributes | ≤ Linaer |

### Requirements

- iOS 15.0+
- Swift 4.0+

### Installation

1. Use: Swift Package Manager.
2. Copy/paste: https://github.com/oscbyspro/DiffableTextViews.
3. Select a **VERSIONED** branch.

```swift
import DiffableTextViews
import NumericTextStyles
import PatternTextStyles
```

# Views

## [DiffableTextField](Documentation/DiffableTextField.md)

A view that uses styles to format and parse text.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :iphone: | SwiftUI | Value, style, done |
| :mountain: | Environment | Uses environment values |
| :balance_scale: | Monospaced | The standard font is monospaced |
| :sewing_needle: | Customizable | Styles may provide default values |

### ProxyTextField

A customization point for the UITextField it is based on.

# Styles

## [NumericTextStyle](Documentation/NumericTextStyle.md)

A style that processes localized numbers in various formats.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :coin: | Values | Decimal, Float(16-64) and (U)Int(8-64) |
| :bow_and_arrow: | Precision | Up to 38 significant digits |
| :bricks: | Bounds | Clamps input/output to specified range |
| :art: | Formats | Number, currency and percent |
| :national_park: | Locales | Supports every locale in Foundation |
| :two: | Bilingual | Accepts both local and system inputs |

### Examples

![DiffableAmountTextField.gif](Assets/DiffableAmountTextField.gif)

```swift
struct DiffableAmountTextField: View {
    @State var amount: Decimal = 0

    var body: some View {
        DiffableTextField($amount) {
            .currency(code: "SEK")
            .bounds((0 as Decimal)...)
            .precision(integer: 1..., fraction: 2)
        }
        .environment(\.locale, Locale(identifier: "en_SE"))
    }
}
```

## [PatternTextStyle](Documentation/PatternTextStyle.md)

A style that processes characters laid out in custom patterns.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :checkered_flag: | Pattern | Characters are laid out as described by a pattern | 
| :chess_pawn: | Placeholders | Placeholders represent not-yet-assigned values |
| :fist_raised: | Independance | Supports multiple placeholders with different rules |
| :ghost: | Invisibility | Pattern suffix can easily be \\.hidden() |
| :feather: | Lightweight | Written in less than 200 lines of [code](Sources/PatternTextStyles/PatternTextStyle.swift) |


### Examples

![DiffablePhoneNumberTextField.gif](Assets/DiffablePhoneNumberTextField.gif)

```swift
struct DiffablePhoneNumberTextField: View {
    @State var phoneNumber: String = ""
    
    var body: some View {
        DiffableTextField($phoneNumber) {
            .pattern("+## (###) ###-##-##")
            .placeholder("#") { $0.isASCII && $0.isNumber }
        }
        .setup({ $0.keyboard(.phonePad) })
    }
}
```
