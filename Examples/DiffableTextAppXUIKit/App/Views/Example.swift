//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import DiffableTextViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Example<Style: DiffableTextStyle>: View {
    typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let style: Style
    let value: Binding<Value>
    let description: String
    @FocusState var focus: Bool

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(value: Binding<Value>, style: Style) {
        self.style = style
        self.value = value
        self.description = String(describing: value.wrappedValue)
    }

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        VStack {
            descriptionText
            diffableTextField
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .onTapGesture { focus.toggle() }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var descriptionText: some View {
        Text(!description.isEmpty ? description : " ")
            .lineLimit(1).frame(maxWidth: .infinity, alignment: .leading).padding()
            .background(Rectangle().strokeBorder(Color(uiColor: .tertiarySystemBackground), lineWidth: 2))
            .background(Color(uiColor: .secondarySystemBackground))
    }
    
    var diffableTextField: some View {
        DiffableTextField("Much wow. Such empty.", value: value, style: style).focused($focus).padding()
            .background(Color(uiColor: .tertiarySystemBackground).ignoresSafeArea(.container, edges: []))
    }
}
