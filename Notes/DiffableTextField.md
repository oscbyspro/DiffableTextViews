# DiffableTextField

A view that uses styles to formats and parses text as you type.

- Available in SwiftUI/iOS.
- Written in SwiftUI/UIKit.

## Defaults

Some non-standard values have been set to enhance the uncustomized experience.

### Values

|   | Value | Description | Comment |
|---|-------|-------------|---------|
| :balance_scale: | Font | Monospaced | As-you-type formatting works best with it |

## Customization

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

### [ProxyTextField](Sources/DiffableTextViews/Views)

```swift
proxy.text.color(.black)
proxy.text.font(.body.monospaced())
proxy.selection.color(.blue, mode: .dimmed)
```

### Style

```swift
extension Style: UIKitDiffableTextStyle {    
    static func onSetup(_ diffableTextField: ProxyTextField) { ... }
}
```

## Examples

![DiffableAmountTextField.gif](../Assets/DiffableAmountTextField.gif)

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

![DiffablePhoneNumberTextField.gif](../Assets/DiffablePhoneNumberTextField.gif)

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
