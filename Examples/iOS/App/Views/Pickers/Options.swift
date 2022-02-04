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

struct Options<Value: Hashable & RawRepresentable & CaseIterable>: View where
Value.RawValue == String, Value.AllCases: RandomAccessCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let selection: Binding<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ selection: Binding<Value>) { self.selection = selection }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Picker(String(describing: Value.self), selection: selection) {
            ForEach(Value.allCases, id: \.self) {
                Text($0.rawValue.capitalized).tag($0)
            }
        }
        .pickerStyle(.segmented)
    }
}
