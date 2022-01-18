# DiffableTextField

A SwiftUI view (UIViewRepresentable) that uses DiffableTextStyle(s) to format text as you type, and convert text to and from its appropriate data type.

### Customization

```swift
extension NumericTextStyle: UIKitDiffableTextStyle {    
    static func setup(diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}
```
