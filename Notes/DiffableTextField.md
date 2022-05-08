# DiffableTextField

A view that uses styles to formats and parses text as you type.

### Defaults

|   | Value | Description | Comment |
|---|-------|-------------|---------|
| :balance_scale: | Font | Monospaced | As-you-type formatting works best with it |

### Locale

```swift
view.environment(\.locale, locale)
```

## Examples

![DiffableTextFieldXAmount.gif](../Assets/DiffableTextFieldXAmount.gif)

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
        DiffableTextField(value: $amount) {
            .currency(code: "SEK")
            .bounds((0 as Decimal)...)
            // .precision(integer: 1..., fraction: 2)
        }
        .environment(\.locale, Locale(identifier: "sv_SE"))
    }
}
```

![DiffableTextFieldXPhone.gif](../Assets/DiffableTextFieldXPhone.gif)

```swift
struct DiffableTextFieldXPhone: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @State var number: String = ""
    let style = PatternTextStyle<String>
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
