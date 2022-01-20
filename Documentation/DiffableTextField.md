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
import PatternTextStyles

struct PatternTextStyleExample: View {
    @State var phone: String = ""
    
    var body: some View {
        DiffableTextField($phone) {
            .pattern("+## (###) ###-##-##")
            .placeholder("#") { $0.isASCII && $0.isNumber }
        }
        .setup({ $0.keyboard(.phonePad) })
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
