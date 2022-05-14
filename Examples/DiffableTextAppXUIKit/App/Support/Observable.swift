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

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Observer<Value, Cache, Output: View>: View {
    typealias Upstream = Binding<Value>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let cache: Cache
    let content: (Upstream, Cache) -> Output
    @ObservedObject var observable: Observable<Value>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ observable: Observable<Value>,
    @ViewBuilder content: @escaping (Upstream) -> Output)
    where Cache == Void {
        self.cache = ()
        self.observable = observable
        self.content = { value, _ in content(value) }
    }
    
    init(_ observable: Observable<Value>, cache: Cache,
    @ViewBuilder content: @escaping (Upstream, Cache) -> Output) {
        self.cache = cache
        self.observable = observable
        self.content = content
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        content(observable.xstorage, cache)
    }
}
