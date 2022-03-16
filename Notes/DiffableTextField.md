# DiffableTextField

A view that uses styles to formats and parses text as you type.

- Available in SwiftUI/iOS.
- Written in SwiftUI/UIKit.

### Defaults

|   | Value | Description | Comment |
|---|-------|-------------|---------|
| :balance_scale: | Font | Monospaced | As-you-type formatting works best with it |

### Locale

```swift
view.environment(\.locale, locale)
```

### Triggers

```swift
view.onSetup (of: .diffableTextField) { proxy in }
view.onUpdate(of: .diffableTextField) { proxy in }
view.onSubmit(of: .diffableTextField) { proxy in }
```

### [ProxyTextField](../Sources/DiffableTextViewsXiOS/Views)

```swift
proxy.text.color(.black)
proxy.text.font(.body.monospaced())
proxy.selection.color(.blue, mode: .dimmed)
```

### [DiffableTextStyleXiOS](../Sources/DiffableTextViewsXiOS/DiffableTextStyle+iOS.swift)

```swift
static func onSetup(_ diffableTextField: ProxyTextField) { ... }
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
        DiffableTextField($amount) {
            .currency(code: "SEK")
            .bounds((0 as Decimal)...)
            // .precision(integer: 1..., fraction: 2)
        }
        .environment(\.locale, Locale(identifier: "en_SE"))
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
        .constant()
}
```
