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
// MARK: * PatternScreenActions
//*============================================================================*

struct PatternScreenActions: View {
    typealias Context = PatternScreenContext
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.context = context
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        HStack {
            Action("clear", action: context.clear)
            Action("pop", action: context.popLast)
            Action("abc", action: context.appendUppercased)
            Action("123", action: context.appendASCIIDigit)
        }
    }
}

