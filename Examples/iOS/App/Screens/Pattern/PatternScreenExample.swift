//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import DiffableTextViews
import PatternTextStyles

//*============================================================================*
// MARK: * PatternScreenExample
//*============================================================================*

/// An examples view that observes frequent changes.
struct PatternScreenExample<Style: UIKitDiffableTextStyle>: View where Style.Value == String {
    typealias Context = PatternScreenContext
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let style: Style
    @ObservedObject var value: Source<String>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context, style: Style) {
        self.style = style
        self.value = context.value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Example(value.binding, style: style)
            .onSetup(of: .diffableTextField) {
                $0.keyboard.view(.numberPad)
            }
    }
}
