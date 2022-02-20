# Swift Issues List

A document with issues that have been encountered.

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

## FormatStyle.Percent: is inaccurate for some types.

### Float16

```swift
let value = 1.23 as Float16
let locale = Locale(identifier: "en_US")
let inaccurate = value.formatted(.percent.locale(locale)) // "123.046875%"
```

### Float32

```swift
let value = 1.23 as Float32
let locale = Locale(identifier: "en_US")
let inaccurate = value.formatted(.percent.locale(locale)) // "123.000002%"
```
