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
// MARK: * NumericScreenSliders
//*============================================================================*

struct NumericScreenSliders: View {
    typealias Values = Interval<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let limits: Values
    @ObservedObject var values: Source<Values>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ title: String, values: Source<Values>, in limits: Values) {
        self.title  = title
        self.values = values
        self.limits = limits
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Sliders(title, values: values.binding, limits: limits.closed)
    }
}

