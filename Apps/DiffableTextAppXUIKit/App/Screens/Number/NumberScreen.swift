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
// MARK: * Screen x Number
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
                //=------------------------------=
                // Pickers
                //=------------------------------=
                Selector.each(selection: $context.kind)
                    .pickerStyle(.segmented)

                Selector.each(selection: $context.format)
                    .pickerStyle(.segmented)
                
                Selector.each(selection: $context.precision)
                    .pickerStyle(.segmented)

                NumberScreenWheels(context)
                //=------------------------------=
                // Sliders
                //=------------------------------=
                Observer(context.$bounds, cache: context.boundsLimits) {
                    Interval("Bounds (9s)", unordered: $0.value.unordered, in: $1)
                }
                
                NumberScreenPrecisionSliders(context)
                
                Spacer()
            }
            
            Divider()
            //=----------------------------------=
            // Example
            //=----------------------------------=
            NumberScreenExample(context)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Previews
//=----------------------------------------------------------------------------=

struct NumberScreen_Previews: PreviewProvider {
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        NumberScreen().preferredColorScheme(.dark)
    }
}
