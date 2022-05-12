//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import SwiftUI

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct NumberScreen: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject private var context = NumberScreenContext()
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            Scroller {
                Segments(context.optionality.xwrapped)
                
                Segments(context.format.xwrapped)
                
                NumberScreenOptionsWheel(context)
                
                VStack(spacing: 16) {
                    NumberScreenIntegerInterval("Bounds (9s)",
                    interval: context.bounds.interval, in: context.boundsLimits)

                    NumberScreenIntegerInterval("Integer digits",
                    interval: context.integer, in: context.integerLimits)

                    NumberScreenIntegerInterval("Fraction digits",
                    interval: context.fraction, in: context.fractionLimits)
                }
                
                Spacer()
            }
            
            Divider()
            
            NumberScreenExample(context)
        }
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct NumberScreen_Previews: PreviewProvider {
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        NumberScreen().preferredColorScheme(.dark)
    }
}