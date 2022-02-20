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

## FormatStyle: Float16 and Float32 are inaccurate.

### Float16

```swift
let value = 1.23 as Float16
let inaccurate = value.formatted(.number.precision(.fractionLength(0...))) // "1.23046875"
```

### Float32

```swift
let value = 1.23 as Float32
let inaccurate = value.formatted(.number.precision(.fractionLength(0...))) // "1.2300000190734863"
```
