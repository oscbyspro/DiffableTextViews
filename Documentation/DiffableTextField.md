# DiffableTextField

A view that uses styles to formats and parses text as you type.

- Available in SwiftUI.
- Written in SwiftUI/UIKit.

## Environment

The environment is used to seamlessly synchronize the view with the app state.

### Values

|   | Value  | Behavior |
|---|--------|----------|
| :national_park: | Locale | Overridden |

## Examples

```swift
import SwiftUI
import DiffableTextViews
import NumericTextStyles

struct DiffableCurrencyAmountTextField: View {
    @State var amount: Decimal = 0
    
    let currencyCode = "SEK"
    let locale = Locale(identifier: "en_SE")
    
    var body: some View {
        DiffableTextField($amount) {
            .currency(code: currencyCode)
            .bounds((0 as Decimal)...)
            .precision(integer: 1..., fraction: 2)
        }
        .environment(\.locale, locale)
    }
}
```

## Customization

### View

Closures may be set and used at specific times in the view's life cycle.

```swift
DiffableTextField($value, style: style)
    .setup ({ (diffableTextField: ProxyTextField) in })
    .update({ (diffableTextField: ProxyTextField) in })
    .submit({ (diffableTextField: ProxyTextField) in })

```

### Style

Styles may configure the view at setup, should it be deemed appropriate. 

```swift
extension Style: UIKitDiffableTextStyle {    
    static func setup(diffableTextField: ProxyTextField) { ... }
}
```
