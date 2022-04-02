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
// MARK: * Wheel
//*============================================================================*

struct Wheel<Value: Hashable, ID: Hashable>: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let values: [Value]
    let selection: Binding<Value>
    let id: KeyPath<Value, ID>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: [Value], selection: Binding<Value>, id: KeyPath<Value, ID>) {
        self.values = values
        self.selection = selection
        self.id = id
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Picker(String(describing: Value.self), selection: selection) {
            ForEach(values, id: id) {
                Text(String(describing: $0[keyPath: id])).tag($0)
            }
        }
        .pickerStyle(.wheel)
    }
}
