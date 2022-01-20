# PatternTextStyle

A styles that process characters laid out in custom patterns of formatting and placeholders.

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

### Phone

A phone number bound to a String. It uses a visible pattern.

```swift
struct PatternTextStyleExample: View {
    @State var phone: String = ""
    
    var body: some View {
        DiffableTextField($phone) {
            .pattern("+## (###) ###-##-##")
            .placeholder("#") { $0.isASCII && $0.isNumber }
        }
        .setup({ $0.keyboard(.phonePad) })
    }
}
```

### Card

A card number bound to a String. It uses an invisible pattern.
    
```swift
struct PatternTextStyleExample: View {
    @State var card: String = ""
    
    var body: some View {
        DiffableTextField($phone) {
            .pattern("#### #### #### ####")
            .placeholder("#") { $0.isASCII && $0.isNumber }
            .hidden()
        }
        .setup({ $0.keyboard(.numberPad) })
    }
}
```
