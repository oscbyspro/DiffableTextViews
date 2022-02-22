# DiffableTextViews

An open-source framework for as-you-type formatting and conversion in iOS.

![DiffableAmountTextField.gif](Assets/DiffableAmountTextField.gif)

![DiffablePhoneNumberTextField.gif](Assets/DiffablePhoneNumberTextField.gif)

### Features

|   | Feature | Description |
|---|---------|-------------|
| :keyboard: | Responsive | Formats and parses text as you type |
| :magic_wand: | Automagical | Binds text to its appropriate data type |
| :hammer_and_wrench: | Versatile | Uses snapshots and attributes |
| :running_man: | Performant | Uses O(n) differentiation algorithms |
| :smiley: | Emojis | Uses native offsets, supports emojis |
| :desert_island: | Standalone | Uses no remote dependencies |
| :open_book: | Open-source | 100% transparent, as it should be |

### Algorithms

It uses three main algorithms to determine text selection.

|   | Algorithm | Description | Complexity |
|---|-----------|-------------|------------|
| :book: | Text | Determines selection when text changes | ≤ Linear |
| :left_right_arrow: | Positions | Determines selection by positions/offsets | ≤ Linear |
| :star: | Attributes | Determines selection based on attributes | ≤ Linaer |

### Requirements

- iOS 15.0+
- Swift 5.0+

### Installation

1. Use: Swift Package Manager.
2. Copy/paste: https://github.com/oscbyspro/DiffableTextViews.
3. Select a **VERSIONED** branch.

```swift
import DiffableTextViews
import NumericTextStyles
import PatternTextStyles
```

# [Examples](Examples/iOS/App)

The iOS example project provides quick-and-easy-to-use customization.

| Numeric | Pattern |
|---------|---------|
<img src="Assets/iOSExampleNumericScreen.png" alt="Numeric" width="250"/> | <img src="Assets/iOSExamplePatternScreen.png" alt="Pattern" width="250"/>

### Installation

Download this package and compile/run it with Xcode.

# Views

## [DiffableTextField](Notes/DiffableTextField.md)

A view that uses styles to format and parse text.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :iphone: | SwiftUI | Value, style, done |
| :mountain: | Environment | Uses environment values |
| :balance_scale: | Monospaced | The standard font is monospaced |
| :sewing_needle: | Customizable | Styles may provide default values |

### ProxyTextField

A UITextField affordance layer and customization point.

# Styles

## [NumericTextStyle](Notes/NumericTextStyle.md) ([Source](Sources/NumericTextStyles), [Tests](Tests/NumericTextStylesTests))

A style that processes localized numbers in various formats.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :coin: | Values | Decimal, Double and (U)Int(8-64) |
| :bow_and_arrow: | Precision | Up to 38 digits of precision |
| :bricks: | Bounds | Clamps input/output to specified range |
| :art: | Formats | Number, currency and percent |
| :national_park: | Locales | Supports every locale in Foundation |
| :two: | Bilingual | Accepts both local and ASCII inputs |

### Examples

![DiffableAmountTextField.gif](Assets/DiffableAmountTextField.gif)

```swift
struct DiffableAmountTextField: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @State var amount: Decimal = 0

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

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

## [PatternTextStyle](Notes/PatternTextStyle.md) ([Source](Sources/PatternTextStyles), [Tests](Tests/PatternTextStylesTests))

A style that processes characters laid out in custom patterns.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :checkered_flag: | Pattern | Characters are laid out as described by a pattern | 
| :chess_pawn: | Placeholders | Placeholders represent not-yet-assigned values |
| :fist_raised: | Independance | Supports multiple placeholders with different rules |
| :ghost: | Invisibility | Pattern suffix can easily be \\.hidden() |

### Examples

![DiffablePhoneNumberTextField.gif](Assets/DiffablePhoneNumberTextField.gif)

```swift
struct DiffablePhoneTextField: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @State var number: String = ""
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        DiffableTextField($number, style: Self.style)
            .diffableTextField_onSetup {
                $0.keyboard(.numberPad)
            }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    static let style = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .constant()
}
```
