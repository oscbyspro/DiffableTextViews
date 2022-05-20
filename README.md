# DiffableTextViews

An open source package for as-you-type formatting in SwiftUI.

![Number](Assets/ViewXNumber.gif)
![Pattern](Assets/ViewXPattern.gif)

### Features

|   | Feature | Description |
|---|---------|-------------|
| :keyboard: | Responsive | Formats text as you type |
| :magic_wand: | Automagical | Binds text to appropriate types |
| :heavy_check_mark: | Proper | Validates and autocorrects input |
| :hammer_and_wrench: | Versatile | Uses snapshots and attributes |
| :running_man: | Performant | O(n) differentiation algorithms |
| :desert_island: | Standalone | Uses no remote dependencies |
| :open_book: | Open | 100% transparent, as it should be |

# Installation

Simple instructions on how to install this package.

### Swift Package Manager

1. Select https://github.com/oscbyspro/DiffableTextViews.
2. Select a **VERSIONED** release.

### Import

```swift
import DiffableTextViews
```

### Requirements

| Swift | iOS   | iPadOS | Mac Catalyst | tvOS  |
|:-----:|:-----:|:------:|:------------:|:-----:|
| 5.0+  | 15.0+ | 15.0+  | 15.0+        | 15.0+ |

# Examples

The example app provides quick-and-easy-to-use customization tools.

| Number | Pattern |
|--------|---------|
<img src="Assets/AppXNumber.png" alt="Number" width="250"/> | <img src="Assets/AppXPattern.png" alt="Pattern" width="250"/>

### Installation

Download this package and compile/run it with Xcode.

# Views

## DiffableTextField

A text field that binds values and formats them as you type.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :iphone: | SwiftUI | Value, style, done |
| :mountain: | Environment | Uses environment values |
| :mag_right: | Focus | Supports SwiftUI.FocusState |

### Environment

```swift
environment(\.locale, _:)
environment(\.layoutDirection, _:)
diffableTextViews_disableAutocorrection(_:)
diffableTextViews_font(_:)
diffableTextViews_foregroundColor(_:)
diffableTextViews_multilineTextAlignment(_:)
diffableTextViews_onSubmit(_:)
diffableTextViews_submitLabel(_:)
diffableTextViews_textContentType(_:)
diffableTextViews_textFieldStyle(_:)
diffableTextViews_textInputAutocapitalization(_:)
diffableTextViews_tint(_:)
```

# Styles

## NumberTextStyle ([Source](Sources/DiffableTextKitXNumber), [Tests](Tests/DiffableTextKitXNumberTests))

A style that binds localized numbers using various formats.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :coin: | Values | Decimal, Double and (U)Int(8-64) |
| :grey_question: | Optional | Optional and non-optional values |
| :art: | Formats | Number, currency and percent |
| :bricks: | Bounds | Clamps values to bounds  |
| :bow_and_arrow: | Precision | Up to 38 digits of precision |
| :national_park: | Locales | Supports all locales in Foundation |
| :two: | Bilingual | Accepts both local and ASCII inputs |

### Examples

![Number](Assets/ViewXNumber.gif)

```swift
import DiffableTextViews
import SwiftUI

//*============================================================================*
// MARK: View
//*============================================================================*

struct DiffableTextFieldXNumber: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @State var amount = 0 as Decimal
    @State var locale = Locale(identifier: "sv_SE")
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

    /// default precision is chosen based on currency
    var body: some View {
        DiffableTextField(value: $amount) {
            .currency(code: "SEK")
            .bounds((0 as Decimal)...)
            // .precision(integer: 1..., fraction: 2)
        }
        .environment(\.locale, locale)
        .diffableTextViews_keyboardType(.decimalPad)
    }
}
```

## PatternTextStyle ([Source](Sources/DiffableTextKitXPattern), [Tests](Tests/DiffableTextKitXPatternTests))

A style that processes characters laid out in custom patterns.

### Features

|   | Feature | Description |
|---|---------|-------------|
| :checkered_flag: | Pattern | Characters are laid out as described by a pattern | 
| :chess_pawn: | Placeholders | Placeholders represent not-yet-assigned values |
| :fist_raised: | Independance | Supports multiple placeholders with different rules |
| :ghost: | Invisibility | Pattern suffix can easily be \\.hidden() |

### Examples

![Pattern](Assets/ViewXPattern.gif)

```swift
import DiffableTextViews
import SwiftUI

//*============================================================================*
// MARK: View
//*============================================================================*

struct DiffableTextFieldXPattern: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @State var number: String = ""
    @State var style = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#") { $0.isASCII && $0.isNumber }
        .equals(())
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        DiffableTextField(value: $number, style: style)
            .diffableTextViews_keyboardType(.numberPad)
    }
}
```

## WrapperTextStyle(s) ([Source](Sources/DiffableTextKit/Styles), [Tests](Tests/DiffableTextKitTests/Styles))

Decorative styles that modify the behavior of their content.

| Style | Description | Method |
|-------|-------------|--------|
| [Constant](Sources/DiffableTextKit/Styles/Constant.swift) | Prevents style transformations | constant() |
| [Equals](Sources/DiffableTextKit/Styles/Equals.swift)  | Binds the style's equality to a proxy value | equals(\_:) |
