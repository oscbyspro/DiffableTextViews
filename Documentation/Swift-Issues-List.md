# Swift Issues List

A document with issues that have been worked around.

## FormatStyle: format then parse fails.

### Problem

NumericTextStyles: 
When the user starts interaction with the view (so editing changes to true), 
the easies way to enforce the format would be to format and parse the value once.
This does not work for all locale and currency pairs, however.

### Example

```swift
// MARK: Bad, Sad, Bad

let code = "SEK"; let locale = Locale(identifier: "en_US")
let style = IntegerFormatStyle<Int>.Currency(code: code).locale(locale)

let value = 123 // 123
let formatted = style.format(value) // SEK 123
let unformatted = try? style.parseStrategy.parse(formatted) // nil
```
