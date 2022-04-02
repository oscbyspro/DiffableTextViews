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
// MARK: * Action
//*============================================================================*

struct Action: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let action: () -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Measurements
    //=------------------------------------------------------------------------=
    
    var height: CGFloat { 24 }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Button(action: action, label: label)
            .tint(Color.gray.opacity(2/3))
            .buttonStyle(.borderedProminent)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    func label() -> some View {
        Text(title).frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
    }
}

