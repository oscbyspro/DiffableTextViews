//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * PatternScreenVisibility
//*============================================================================*

struct PatternScreenVisibility: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @ObservedObject var visible: Source<Bool>
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Toggle(isOn: visible.binding, label: label)
            .tint(Color.gray.opacity(2/3))
            .background(Rectangle().strokeBorder(.gray))
            .animation(.default, value: visible.storage)
            .toggleStyle(.button)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    func label() -> some View {
        Text(visible.storage ? "Visible" : "Hidden")
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .animation(nil, value: visible.storage)
    }
}
