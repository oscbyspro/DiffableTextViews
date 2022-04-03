# DiffableTextViews

An open source package for as-you-type formatting in SwiftUI.

![DiffableTextFieldXAmount.gif](Assets/DiffableTextFieldXAmount.gif)

![DiffableTextFieldXPhone.gif](Assets/DiffableTextFieldXPhone.gif)

### Features

|   | Feature | Description |
|---|---------|-------------|
| :keyboard: | Responsive | Formats text as you type |
| :magic_wand: | Automagical | Binds text to a chosen data type |
| :heavy_check_mark: | Proper | Validates and autocorrects input |
| :hammer_and_wrench: | Versatile | Uses snapshots and attributes |
| :running_man: | Performant | Uses O(n) differentiation algorithms |
| :desert_island: | Standalone | Uses no remote dependencies |
| :open_book: | Open source | 100% transparent, as it should be |

### [Algorithms](Sources/DiffableTextKit/Models)

It uses three main algorithms to determine text selection.

|   | Algorithm | Description | Complexity |
|---|-----------|-------------|------------|
| :book: | Text | Determines selection when text changes | ≤ Linear |
| :left_right_arrow: | Positions | Determines selection by positions/offsets | ≤ Linear |
| :star: | Attributes | Determines selection based on attributes | ≤ Linaer |

# Installation

Simple instructions on how to install this package.

### Swift Package Manager

1. Select: https://github.com/oscbyspro/DiffableTextViews.
2. Select a **VERSIONED** release.

### Imports

```swift
import DiffableTextViews
```

### Requirements

| Swift | iOS   | iPadOS | Mac Catalyst | tvOS  |
|:-----:|:-----:|:------:|:------------:|:-----:|
| 5.0+  | 15.0+ | 15.0+  | 15.0+        | 15.0+ |

# [Examples](Examples/DiffableTextAppXUIKit/App)

The example app provides quick-and-easy-to-use customization tools.

| Numeric | Pattern |
|---------|---------|
<img src="Assets/DiffableTextAppXUIKitXNumeric.png" alt="Numeric" width="250"/> | <img src="Assets/DiffableTextAppXUIKitXPattern.png" alt="Pattern" width="250"/>

### Installation

Download this package and compile/run it with Xcode.

# Views

## [DiffableTextField](Notes/DiffableTextField.md)

A text field that binds values and formats them as you type.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :iphone: | SwiftUI | Value, style, done |
| :mountain: | Environment | Uses environment values |
| :mag_right: | Focusable | Supports use of @FocusState |
| :sewing_needle: | Customizable | Exposes [ProxyTextField](Sources/DiffableTextKitXUIKit/Views/ProxyTextField.swift) |
| :zzz: | Convenient | Styles have sensible defaults |
| :balance_scale: | Monospaced | Standard font is monospaced |
| :smiley: | Emojis | Uses native offsets |

# Styles

## [NumericTextStyle](Notes/NumericTextStyle.md) ([Source](Sources/DiffableTextStylesXNumeric), [Tests](Tests/DiffableTextStylesXNumericTests))

A style that binds localized numbers using various formats.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :coin: | Values | Decimal, Double and (U)Int(8-64) |
| :bow_and_arrow: | Precision | Up to 38 digits of precision |
| :bricks: | Bounds | Clamps values to a closed range  |
| :art: | Formats | Number, currency and percent |
| :national_park: | Locales | Supports every Foundation.Locale |
| :two: | Bilingual | Accepts both local and ASCII inputs |

### Examples

![DiffableTextFieldXAmount.gif](Assets/DiffableTextFieldXAmount.gif)

```swift
struct DiffableTextFieldXAmount: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @State var amount: Decimal = 0

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

    /// default precision is chosen based on currency
    var body: some View {
        DiffableTextField($amount) {
            .currency(code: "SEK")
            .bounds((0 as Decimal)...)
            // .precision(integer: 1..., fraction: 2)
        }
        .environment(\.locale, Locale(identifier: "sv_SE"))
    }
}
```

## [PatternTextStyle](Notes/PatternTextStyle.md) ([Source](Sources/DiffableTextStylesXPattern), [Tests](Tests/DiffableTextStylesXPatternTests))

A style that processes characters laid out in custom patterns.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :checkered_flag: | Pattern | Characters are laid out as described by a pattern | 
| :chess_pawn: | Placeholders | Placeholders represent not-yet-assigned values |
| :fist_raised: | Independance | Supports multiple placeholders with different rules |
| :ghost: | Invisibility | Pattern suffix can easily be \\.hidden() |

### Examples

![DiffableTextFieldXPhone.gif](Assets/DiffableTextFieldXPhone.gif)

```swift
struct DiffableTextFieldXPhone: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @State var number: String = ""
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        DiffableTextField($number, style: Self.style)
            .onSetup(of: .diffableTextField) { 
                $0.keyboard.view(.numberPad)
            }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    static let style = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#") { $0.isASCII && $0.isNumber }
        .equals(())
}
```

## [WrapperTextStyle(s)](Notes/WrapperTextStyle.md) ([Source](Sources/DiffableTextStylesXWrapper/), [Tests](Tests/DiffableTextStylesXWrapperTests))

Modifies the behavior of its content.

## Constant 

Prevents style transformations.

```swift
style.constant()
```

## Equals

Binds the style's equality to a proxy value.

```swift
style.equals(())
style.equals(value)
```
