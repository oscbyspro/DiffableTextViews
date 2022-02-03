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
// MARK: * Choices
//*============================================================================*

struct Choices<Options: RandomAccessCollection, Content: View>: View where Options.Element: Hashable {
    typealias Selection = Options.Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let options: Options
    let selection: Binding<Selection>
    let content: (Selection) -> Content
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ options: Options, selection: Binding<Selection>, content: @escaping (Selection) -> Content) {
        self.options = options
        self.selection = selection
        self.content = content
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Picker(title, selection: selection) {
            ForEach(options, id: \.self, content: content)
        }
        .pickerStyle(.segmented)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var title: String {
        String(describing: Selection.self)
    }
}
