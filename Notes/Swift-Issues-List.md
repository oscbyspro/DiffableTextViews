# Swift Issues List

A document with issues that have been worked around.

## FormatStyle: UInt(64) > Int(64).max crashes.

```swift
let value = UInt(Int.max) + 1
let crash = value.formatted(.number)
```

## FormatStyle: parse(format(value)) fails.

```swift
let code = "SEK"; let locale = Locale(identifier: "en_US")
let style = IntegerFormatStyle<Int>.Currency(code: code).locale(locale)
let crash = try! style.parseStrategy.parse(style.format(123))
```
