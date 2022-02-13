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

## Environment

The environment is used to seamlessly synchronize the view with the app state.

### Values

|   | Value  | Behavior |
|---|--------|----------|
| :national_park: | Locale | Overridden |

## Customization

### Style

Styles may configure the view at setup, should it be deemed appropriate. 

```swift
extension Style: UIKitDiffableTextStyle {    
    static func onSetup(_ diffableTextField: ProxyTextField) { ... }
}
```

### View

Closures may be set and used at specific times in the view's life cycle.

```swift
DiffableTextField($value, style: style)
    .diffableTextField_onSetup ({ _ in })
    .diffableTextField_onUpdate({ _ in })
    .diffableTextField_onSubmit({ _ in })

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
            .diffableTextField_onSetup {
                proxy in
                proxy.keyboard(.numberPad)
            }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    static let style = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .constant().reference()
}
```
