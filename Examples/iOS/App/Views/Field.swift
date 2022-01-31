//
//  Field.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-31.
//

import SwiftUI
import DiffableTextViews

//*============================================================================*
// MARK: * Field
//*============================================================================*

struct Field<Style: UIKitDiffableTextStyle>: View {
    typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    let style: Style
    let value: Binding<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    init(_ value: Binding<Value>, style: () -> Style) {
        self.value = value
        self.style = style()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        DiffableTextField(value, style: style)
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
    }
}

//*============================================================================*
// MARK: * Field x Previews
//*============================================================================*

struct FieldPreviews: PreviewProvider {
    static var previews: some View {
        Field(.constant(123), style: .number)
            .preferredColorScheme(.dark)
    }
}
