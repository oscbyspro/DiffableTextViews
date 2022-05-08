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
// MARK: Declaration
//*============================================================================*

struct Toggler: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let isOn: Observable<Bool>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ title: String, isOn: Observable<Bool>) {
        self.title = title; self.isOn = isOn
    }

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Toggle(isOn: isOn.xwrapped) {
            Text(title)
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .animation(nil, value: isOn.wrapped)
        }
        .tint(Color.gray.opacity(0.6))
        .background(Rectangle().strokeBorder(.gray))
        .animation(.default, value: isOn.wrapped)
        .toggleStyle(.button)
    }
}
