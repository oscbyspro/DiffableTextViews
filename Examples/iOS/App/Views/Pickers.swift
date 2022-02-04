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
// MARK: * Pickers
//*============================================================================*

#warning("Selection, data, id.")
struct Pickers: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let items: [Int]
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        foundation.hidden().overlay(content).pickerStyle(.wheel)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var foundation: some View {
        Picker(String(), selection: .constant(0)) { }
    }
    
    #warning("Needs real identifiers.")
    var content: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    Text("\(item)")
                }
                .frame(width: proxy.size.width / CGFloat(items.count))
            }
        }
    }
}

//*============================================================================*
// MARK: * PickersPreviews
//*============================================================================*

struct PickersPreviews: PreviewProvider {
    static var previews: some View {
        Pickers(items: [1, 2, 3])
    }
}
