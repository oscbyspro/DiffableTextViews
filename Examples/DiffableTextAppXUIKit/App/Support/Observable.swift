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
    typealias Subbinding<T> = KeyPath<Binding<Value>, Binding<T>>
    
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
    
    var projectedValue: Observable {
        get { self }
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Observer<Value, Content: View>: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let content: (Binding<Value>) -> Content
    @ObservedObject var observable: Observable<Value>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    
    init(_ observable: Observable<Value>, @ViewBuilder
    content: @escaping (Binding<Value>) -> Content) {
        self.observable = observable; self.content = content
    }
    
    init<T>(_ observable: Observable<Value>, cache:  T,
    @ViewBuilder content: @escaping (Binding<Value>, T) -> Content) {
        self.observable = observable; self.content = { content($0, cache) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        content($observable.value)
    }
}
