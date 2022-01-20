# DiffableTextField

A view that uses styles to format text as you type, and convert it to and from its appropriate data type.

- Available in SwiftUI.
- Written in SwiftUI/UIKit.

### Examples

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
