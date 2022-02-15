# NumericTextStyle

Styles that process text bound to number types.

![DiffableAmountTextField.gif](../Assets/DiffableAmountTextField.gif)

## Locales

Supports every locale available in the Foundation framework.

- It accepts both localized and ASCII inputs.
- It fetches and caches characters at runtime.

## Formats

Uses format styles introduced in iOS 15.0.

### Instances

|   | Format | Availability. |
|---|--------|---------------|
| :hash: | Number | All |
| :coin: | Currency | All |
| :100: | Percent | Nonintegers |

## Bounds

Determines the input and output space in terms of values.

### Behavior

- If the value is outside its range, the value will be rounded.
- A negative sign will automatically be inserted when: min < 0 and max ≤ 0.

### Enforcement

- Lower bound is enforced when the view is: active.
- Upper bound is enforced when the view is: active.

## Precision

Determines the input and output space in terms of digits.

### Behavior

- If the value is longer than its upper bound, the value will be trimmed to that length.
- If the value is shorter than its lower bound, redundant zeros will be added to the value.

### Enforcement

- Lower bound is enforced when the view is: idle.
- Upper bound is enforced when the view is: active.

## Values

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
        - precision: ---
        - bounds: ------

    - Int8:
        - precision: 3
        - bounds: -128 to 127

    - Int16:
        - precision: 5
        - bounds: -32,768 to 32,767

    - Int32:
        - precision: 10
        - bounds: -2,147,483,648 to 2,147,483,647

    - Int64:
        - precision: 19
        - bounds: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807

    - UInt:
        - precision: ---
        - bounds: ------

    - UInt8:
        - precision: 3
        - bounds: 0 to 255

    - UInt16:
        - precision: 5
        - bounds: 0 to 65,535

    - UInt32:
        - precision: 10
        - bounds: 0 to 2,147,483,647

    - UInt64:
        - precision: 19
        - bounds: 0 to 9,223,372,036,854,775,807 (Int64.max)

## Behavior

      - Bounds take effect before precision (see enforcement sections).
      - Sign is set by inserting a sign character anywhere in the text.

## Examples

![DiffableAmountTextField.gif](../Assets/DiffableAmountTextField.gif)

```swift
struct DiffableAmountTextField: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @State var amount: Decimal = 0

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

    var body: some View {
        DiffableTextField($amount) {
            .currency(code: "SEK")
            .bounds((0 as Decimal)...)
            .precision(integer: 1..., fraction: 2)
        }
        .environment(\.locale, Locale(identifier: "en_SE"))
    }
}
```
