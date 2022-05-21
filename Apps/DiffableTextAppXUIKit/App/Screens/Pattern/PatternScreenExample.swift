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

//*============================================================================*
// MARK: * Screen x Pattern x Example
//*============================================================================*

struct PatternScreenExample: View {
    typealias Context = PatternScreenContext
    typealias PatternID = Context.PatternID
    typealias VisibilityID = Context.VisibilityID

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context

    @ObservedObject var pattern: Observable<PatternID>
    @ObservedObject var visibility: Observable<VisibilityID>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.context = context
        self.pattern = context.$pattern
        self.visibility = context.$visibility
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var style: PatternTextStyle<String> {
        let base   = (pattern == .phone) ? context.phone : context.card
        let hidden = (visibility == .hidden); return base.hidden(hidden)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Observer(context.$value, cache:  style) {
            Example(value: $0.value, style: $1)
        }
        .diffableTextViews_keyboardType(.numberPad)
    }
}
