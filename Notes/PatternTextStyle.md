# PatternTextStyle

A styles that process characters laid out in custom patterns of formatting and placeholders.

![DiffablePhoneNumberTextField.gif](../Assets/DiffablePhoneNumberTextField.gif)

## Pattern

A collection of characters.

- Its suffix may be hidden with the \\.hidden() method.

## Placeholder

A placeholder reserves a place for another character in a pattern. 

- To replace a placeholder, the replacement character must satisfy its predicate.
- There may be multiple placeholders and each may use independent validation rules.

## Value

A collection of characters. 

- Its size is limited to the number of placeholders in the pattern it tries to fill.

## Examples

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

![DiffablePhoneNumberTextField.gif](../Assets/DiffableCardNumberTextField.gif)

```swift
struct DiffableCardTextField: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var number: String = ""
    
    //=------------------------------------------------------------------------=
    // MARK: State
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
        .pattern("#### #### #### ####")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .hidden().constant().reference()
}
```
