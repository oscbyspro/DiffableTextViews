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
// MARK: Declaration
//*============================================================================*

struct NumberScreen: NumberScreenView {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject private var context = Context()
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            Scroller {
                //=------------------------------=
                // Pickers
                //=------------------------------=
                Selector.each(selection: $context.optionality)
                    .pickerStyle(.segmented)

                Selector.each(selection: $context.format)
                    .pickerStyle(.segmented)

                NumberScreenWheels(context)
                //=------------------------------=
                // Intervals
                //=------------------------------=
                Observer(context.$bounds) {
                    NumberScreenInterval("Bounds (9s)",
                    interval: $0.integers, in: context.boundsLimits)
                }

                Spacer(minLength: 16).fixedSize()
                
                Observer(context.$integer) {
                    NumberScreenInterval("Integer digits",
                    interval: $0, in: context.integerLimits)
                }
                
                Spacer(minLength: 16).fixedSize()

                Observer(context.$fraction) {
                    NumberScreenInterval("Fraction digits",
                    interval: $0, in: context.fractionLimits)
                }
                
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
