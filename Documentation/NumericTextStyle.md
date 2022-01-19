# NumericTextStyle

A style that formats and converts text to and from number types.

## TODOs

|   | Feature | Description |
|---|---------|-------------|
| :coin: | Values | Decimal, Float(16-64) and (U)Int(8-64). |
| :bow_and_arrow: | Precision | Up to 38 significant digits. |
| :bricks: | Bounds | Clamps input and output to specified range. |
| :art: | Formats | Number, currency and percent. |
| :national_park: | Locales | Every locale in the Foundation framework. |
| :two: | Bilingual | Accepts both local and system characters. |

## Locales

    - Supports every locale available in the Foundation framework.
    - Input and output characters are retrieved and cached at runtime.

## Formats

    - Number
    - Currency
    - Percent (floating point values)

## Values

Values supported by this framework.

### Decimals

| Value | Precision | Bounds | Comments |
|-------|-----------|--------|----------|
| Decimal | 38 | ±99,999,999,999,999,999,999,999,999,999,999,999,999 | |

### Floats

| Value | Precision | Bounds | Comments |
|-------|-----------|--------|----------|
| Float16 |  3 | ±999 | |
| Float32 |  7 | ±9,999,999 | |
| Float64 | 15 | ±999,999,999,999,999 | |

### Ints

| Value | Precision | Bounds | Comments |
|-------|-----------|--------|----------|
| Int   | \* | \* | Depends on the system. |
| Int8  |  3 | -128...127 | |
| Int16 |  5 | -32,768...32,767 | |
| Int32 | 10 | -2,147,483,648...2,147,483,647 | |
| Int64 | 19 | -9,223,372,036,854,775,808...9,223,372,036,854,775,807 | |

### UInts

| UInt   | \* | \* | Depends on the system. |
| UInt8  |  3 | 0...255 | |
| UInt16 |  5 | 0...65,535 | |
| UInt32 | 10 | 0...2,147,483,647 | |
| UInt64 | 19 | 0...9,223,372,036,854,775,807 | Limited to Int64.max |
