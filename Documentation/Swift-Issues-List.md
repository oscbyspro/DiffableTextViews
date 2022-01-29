# Swift Issues List

A document with issues that have been worked around.

## FormatStyle: UInt(64) > Int(64).max crashes.

### Problem

NumericTextStyles:
UInt(64) cannot be formatted past Int(64).max, or it crashes.

### Example

```swift
let value = UInt(Int.max) + 1
let crash = value.formatted(.number)
```

## FormatStyle: parse(format(value)) fails.

### Problem

NumericTextStyles:
When changes are made upstream, or the user starts interaction with the view, 
the easies way to enforce precision is to format and parse the value once.
This does not work for all locale and currency pairs, which is unexpected and weird.

### Example

```swift
let code = "SEK"; let locale = Locale(identifier: "en_US")
let style = IntegerFormatStyle<Int>.Currency(code: code).locale(locale)
let crash = try! style.parseStrategy.parse(style.format(123))
```
