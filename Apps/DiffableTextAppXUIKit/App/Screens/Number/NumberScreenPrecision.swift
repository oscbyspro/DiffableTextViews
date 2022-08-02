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
// MARK: * Screen x Number x Precision x Sliders
//*============================================================================*

struct NumberScreenPrecisionSliders: View {
    typealias Context = NumberScreenContext
    typealias PrecisionID = Context.PrecisionID
    typealias Slider = Observer<Observable<(Int, Int)>, Interval>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    @ObservedObject var precision: Observable<PrecisionID>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.context   = context
        self.precision = context.$precision
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var body: some View {
        VStack(spacing: 0) {
            primary
            secondary
        }
        .animation(.default, value: precision.value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var primary: some View {
        precision == .total ? digits : integer
    }
    
    @ViewBuilder var secondary: some View {
        if precision == .sides { fraction }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var digits: Slider {
        Observer(context.$digits, cache: context.digitsLimits) {
            Interval("Total precision", unordered: $0.value, in: $1)
        }
    }
    
    var integer: Slider {
        Observer(context.$integer, cache: context.integerLimits) {
            Interval("Integer precision", unordered: $0.value, in: $1)
        }
    }
    
    var fraction: Slider {
        Observer(context.$fraction, cache: context.integerLimits) {
            Interval("Fraction precision", unordered: $0.value, in: $1)
        }
    }
}
