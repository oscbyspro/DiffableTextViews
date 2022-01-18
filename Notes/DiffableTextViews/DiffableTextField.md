# DiffableTextField

A SwiftUI (UIViewRepresentable) that uses DiffableTextStyles to format text as you type.

### Customization

```swift
extension NumericTextStyle: UIKitDiffableTextStyle {    
    static func setup(diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}
```
