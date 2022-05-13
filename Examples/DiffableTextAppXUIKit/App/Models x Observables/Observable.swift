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
// MARK: Declaration
//*============================================================================*

@propertyWrapper final class Observable<Value>: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @Published var storage: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ storage: Value) {
        self.storage = storage
    }
    
    init(wrappedValue: Value) {
        self.storage = wrappedValue
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var xstorage: Binding<Value> {
        Binding { self.storage } set: { self.storage = $0 }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var projectedValue: Observable {
        self
    }
    
    var wrappedValue: Value {
        get { storage }
        set { storage = newValue }
    }
}
