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

struct Observer<Observable: ObservableObject, Content: View>: View {
    typealias Wrapper = ObservedObject<Observable>.Wrapper
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let content: (Wrapper) -> Content
    @ObservedObject var observable: Observable

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_    observable: Observable,
    @ViewBuilder content: @escaping (Wrapper) -> Content) {
        self.observable = observable; self.content = content
    }
    
    init<T>(_ observable: Observable, cache:  T,
    @ViewBuilder content: @escaping (Wrapper, T) -> Content) {
        self.observable = observable; self.content = { content($0, cache) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        content($observable)
    }
}

