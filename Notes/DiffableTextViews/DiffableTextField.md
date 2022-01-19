# DiffableTextField

A SwiftUI view (UIViewRepresentable) that uses DiffableTextStyle(s) to format text as you type, and convert text to and from its appropriate data type.


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
