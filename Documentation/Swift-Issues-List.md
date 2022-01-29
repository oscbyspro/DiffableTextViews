# Swift Issues List

A document with issues that have been worked around.

## FormatStyle: format then parse fails.

### Problem

NumericTextStyles:
When changes are made upstream, or the user starts interaction with the view, 
the easies way to enforce its precision would be to format and parse the value once.
This does not work for all locale and currency pairs, however, which is weird.

### Example

```swift
// MARK: Bad, Sad, Bad

let code = "SEK"; let locale = Locale(identifier: "en_US")
let style = IntegerFormatStyle<Int>.Currency(code: code).locale(locale)

let value = 123 // 123
let formatted = style.format(value) // SEK 123
let unformatted = try? style.parseStrategy.parse(formatted) // nil
```
