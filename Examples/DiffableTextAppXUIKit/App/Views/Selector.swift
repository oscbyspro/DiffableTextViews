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

struct Selector<Value: Hashable, ID: Hashable>: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let values: [Value]
    let selection: Binding<Value>
    let id: KeyPath<Value, ID>
    let label: (Value) -> String

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: [Value], selection: Binding<Value>, id: KeyPath<Value, ID>) {
        self.values = values; self.selection = selection; self.id = id
        self.label = { value  in String(describing: value[keyPath: id]) }
    }
    
    init(selection: Binding<Value>) where ID == String,
    Value: RawRepresentable, Value.RawValue == ID,
    Value: CaseIterable, Value.AllCases == [Value] {
        self.values = Value.allCases; self.selection = selection
        self.id = \.rawValue; self.label = \.rawValue.capitalized
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Picker(String(describing: Value.self), selection: selection) {
            ForEach(values, id: id) {
                Text(label($0)).tag($0)
            }
        }
    }
}

