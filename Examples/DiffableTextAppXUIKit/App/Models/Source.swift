//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Combine
import SwiftUI

//*============================================================================*
// MARK: * Source
//*============================================================================*

final class Source<Value>: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var content: Value {
        willSet { objectWillChange.send() }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ storage: Value) { self.content = storage }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Uses strong references.
    var binding: Binding<Value> {
        Binding { self.content } set: { self.content = $0 }
    }
}
