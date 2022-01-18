# NumericTextStyle

A diffable text style that formats and converts text to and from number types.

### Locales

    - Foundation

### Formats

    - Number
    - Currency
    - Percent
     

### Values

    - Decimal:
        - precision: 38
        - bounds: ±99,999,999,999,999,999,999,999,999,999,999,999,999

    - Float16:
        - precision: 3
        - bounds: ±999

    - Float32 = Float:
        - precision: 7
        - bounds: ±9,999,999

    - Float64 = Double:
        - precision: 15
        - bounds: ±999,999,999,999,999

    - Int:
        - precision: depends on the system.
        - bounds:    depends on the system.

    - Int8:
        - precision: 3
        - bounds: -128...127

    - Int16:
        - precision: 5
        - bounds: -32,768...32,767

    - Int32:
        - precision: 10
        - bounds: -2,147,483,648...2,147,483,647

    - Int64:
        - precision: 19
        - bounds: -9,223,372,036,854,775,808...9,223,372,036,854,775,807

    - UInt:
        - precision: depends on the system.
        - bounds:    depends on the system.

    - UInt8:
        - precision: 3
        - bounds: 0...255

    - UInt16:
        - precision: 5
        - bounds: 0...65,535

    - UInt32:
        - precision: 10
        - bounds: 0...2,147,483,647

    - UInt64:
        - precision: 19
        - bounds: 0...9,223,372,036,854,775,807 (limited by Int64.max)
