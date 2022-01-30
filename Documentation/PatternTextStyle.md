# PatternTextStyle

A styles that process characters laid out in custom patterns of formatting and placeholders.

![DiffablePhoneNumberTextField.gif](../Assets/DiffablePhoneNumberTextField.gif)

## Pattern

A collection of characters.

- Its suffix may be hidden with the \\.hidden() method.

## Placeholder

A placeholder is a character used to reserves positions in a pattern. 

- To replace a placeholder, the replacement character must satisfy its predicate.
- There may be multiple placeholders and each may use independent validation rules.

## Value

A collection of characters. 

- Its size is limited to the number of placeholders in the pattern it tries to fill.

## Examples

![DiffablePhoneNumberTextField.gif](../Assets/DiffablePhoneNumberTextField.gif)

```swift
struct DiffablePhoneNumberTextField: View {
    @State var phoneNumber: String = ""
    
    var body: some View {
        DiffableTextField($phoneNumber) {
            .pattern("+## (###) ###-##-##")
            .placeholder("#") { $0.isASCII && $0.isNumber }
            .constant()
        }
        .diffableTextField_onSetup({ $0.keyboard(.phonePad) })
    }
}
```

![DiffablePhoneNumberTextField.gif](../Assets/DiffablePaymentNumberTextField.gif)

```swift
struct DiffablePaymentNumberTextField: View {
    @State var paymentNumber: String = ""
    
    var body: some View {
        DiffableTextField($paymentNumber) {
            .pattern("#### #### #### ####")
            .placeholder("#") { $0.isASCII && $0.isNumber }
            .hidden().constant()
        }
        .diffableTextField_onSetup({ $0.keyboard(.numberPad) })
    }
}
```
