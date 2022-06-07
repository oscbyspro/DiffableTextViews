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
// MARK: * Selector
//*============================================================================*

struct Selector<Data, ID, Label>: View where
Data: RandomAccessCollection, Data.Element: Hashable,
ID: Hashable, Label: View {
    typealias Value = Data.Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let data: Data
    let selection: Binding<Value>
    let id: KeyPath<Value, ID>
    let label: (Value) -> Label

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ data: Data,
    selection: Binding<Value>,
    id: KeyPath<Value, ID>,
    label: @escaping (Value) -> Label) {
        self.data = data
        self.selection = selection
        self.id = id
        self.label = label
    }
    
    init(_ data: Data,
    selection: Binding<Value>,
    label: @escaping (Value) -> String)
    where ID == Value, Label == Text {
        self.data = data
        self.selection = selection
        self.id = \.self
        self.label = { Text(label($0)) }
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    static func each(selection: Binding<ID>) -> Self
    where ID: CaseIterable, Data == ID.AllCases, Label == Text,
    Value: RawRepresentable, Value.RawValue == String {
        Self(ID.allCases, selection: selection, id: \.self) {
            Text($0.rawValue.capitalized)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Picker(String(describing: Value.self), selection: selection) {
            ForEach(data, id: id, content: label)
        }
    }
}

