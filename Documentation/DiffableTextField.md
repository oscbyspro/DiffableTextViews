# DiffableTextField

A view that uses styles to format text as you type, and convert it to and from its appropriate data type.

- Available in SwiftUI.
- Written in SwiftUI/UIKit as a UIViewRepresentable.

### Customization: View Life Cycle

```swift
diffableTextField
    .setup ({ proxyTextField in }) // on UIView creation
    .update({ proxyTextField in }) // on UIView update
    .submit({ proxyTextField in }) // on return tap

```

### Customization: Style

```swift
extension NumericTextStyle: UIKitDiffableTextStyle {    
    static func setup(diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}
```
