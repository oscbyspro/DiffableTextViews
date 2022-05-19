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

@propertyWrapper final class Observable<Value>: ObservableObject {
    typealias KeyPath<T> = ReferenceWritableKeyPath<Observable, T>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @Published var value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ value: Value) {
        self.value = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Wrapper
    //=------------------------------------------------------------------------=
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }
    
    var projectedValue: Observable { self }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    static func == (lhs: Observable, rhs: Value) -> Bool where Value: Equatable {
        lhs.value == rhs
    }
    
    static func == (lhs: Value, rhs: Observable) -> Bool where Value: Equatable {
        lhs == rhs.value
    }
}
