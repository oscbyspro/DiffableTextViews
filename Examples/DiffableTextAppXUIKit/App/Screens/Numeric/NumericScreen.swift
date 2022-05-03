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
// MARK: Declaration
//*============================================================================*

struct NumericScreen: View {
    typealias Context = NumericScreenContext

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject private var context = Context()
    @EnvironmentObject private var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            controls
            Divider()
            NumericScreenExamples(context)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var controls: some View {
        Scroller {
            Segments(context.kind.binding)
            
            NumericScreenWheels(context)
            
            NumericScreenSliders("Bounds (9s)",
            interval: context.bounds.interval, in: Context.boundsLimits)
            
            NumericScreenSliders("Integer digits",
            interval: context.integer, in: Context.integerLimits)
            
            NumericScreenSliders("Fraction digits",
            interval: context.fraction, in: Context.fractionLimits)
            
            Spacer()
        }
    }
}

//*============================================================================*
// MARK: Previews
//*============================================================================*

struct NumericTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        NumericScreen()
            .preferredColorScheme(.dark)
            .environmentObject(Storage())
    }
}
