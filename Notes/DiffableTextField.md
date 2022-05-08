# DiffableTextField

A view that uses styles to formats and parses text as you type.

### Defaults

|   | Value | Description | Comment |
|---|-------|-------------|---------|
| :balance_scale: | Font | Monospaced | As-you-type formatting works best with it |

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

## Examples

![DiffableTextFieldXAmount.gif](../Assets/DiffableTextFieldXAmount.gif)

```swift
import DiffableTextViews
import SwiftUI

//*============================================================================*
// MARK: View
//*============================================================================*

struct DiffableTextFieldXAmount: View {

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
    }
}
```

![DiffableTextFieldXPhone.gif](../Assets/DiffableTextFieldXPhone.gif)

```swift
import DiffableTextViews
import SwiftUI

//*============================================================================*
// MARK: View
//*============================================================================*

struct DiffableTextFieldXPhone: View {

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
