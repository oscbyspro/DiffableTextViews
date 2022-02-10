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
    static let style = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .constant().storable()

    @State var phoneNumber: String = ""
        
    var body: some View {
        DiffableTextField($phoneNumber, style: Self.style)
            .diffableTextField_onSetup({ $0.keyboard(.phonePad) })
    }
}
```

![DiffablePhoneNumberTextField.gif](../Assets/DiffableCardNumberTextField.gif)

```swift
struct DiffableCardNumberTextField: View {
    static let style = PatternTextStyle<String>
        .pattern("#### #### #### ####")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .hidden().constant().storable()
    
    @State var cardNumber: String = ""
    
    var body: some View {
        DiffableTextField($cardNumber, style: Self.style)
            .diffableTextField_onSetup({ $0.keyboard(.numberPad) })
    }
}
```
