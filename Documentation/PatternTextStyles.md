#  PatternTextStyles

Styles that processes characters laid out in custom patterns.

# PatternTextStyle\<Pattern, Value\>

A style that binds values to a custom pattern with placeholder characters.

## Pattern

A pattern is a collection of characters to compare value characters against.

### Hidden

The suffix of the pattern is hidden with the \\.hidden() method.

## Placeholder

A placeholder is a character used by the pattern to reserves a position for value characters. It has a predicate used to validate candidates for the position. To replace a placeholder, the replacement character must satisfy the predicate.

### Independent

There may be multiple placeholder characters and each may use a different validation rules.

### Value

A value is a collection of characters. Its size is limited to the number of placeholder characters in the pattern.

## Examples

### Phone

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
