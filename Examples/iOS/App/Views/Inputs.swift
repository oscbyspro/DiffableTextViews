//
//  Inputs.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-01.
//

import SwiftUI
import DiffableTextViews

//*============================================================================*
// MARK: * Field
//*============================================================================*

struct Inputs<Style: UIKitDiffableTextStyle>: View {
    typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @SwiftUI.FocusState var focused: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    let value: Binding<Value>
    let style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    init(_ value: Binding<Value>, style: () -> Style) {
        self.init(value, style: style())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var description: String {
        let description = String(describing: value.wrappedValue)
        return !description.isEmpty ? description : "\u{200B}"
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        VStack {
            descriptionText
            diffableTextField
        }
        .background(Color.white.opacity(0.001))
        .onTapGesture(perform: { focused.toggle() })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var descriptionText: some View {
        Text(description)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(border)
    }
    
    var diffableTextField: some View {
        DiffableTextField(value, style: style)
            .padding()
            .background(color)
            .focused($focused)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Subcomponents
    //=------------------------------------------------------------------------=
    
    var color: some ShapeStyle {
        Color(uiColor: .tertiarySystemBackground)
    }
    
    var border: some View {
        Rectangle().strokeBorder(color, lineWidth: 2)
    }
}

//*============================================================================*
// MARK: * Inputs x Previews
//*============================================================================*

struct InputsPreviews: PreviewProvider {
    static var previews: some View {
        Inputs(.constant(123), style: .number)
            .preferredColorScheme(.dark)
    }
}
