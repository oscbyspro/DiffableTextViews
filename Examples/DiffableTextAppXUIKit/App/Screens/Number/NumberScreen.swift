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

struct NumberScreen: View {
    typealias Context = NumberScreenContext

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
                // Sliders
                //=------------------------------=
                Observer(context.$bounds, cache: context.boundsLimits) {
                    Intervalizer("Bounds (9s)", interval: $0.integers, in: $1)
                }
                
                Observer(context.$integer, cache: context.integerLimits) {
                    Intervalizer("Integer digits", interval: $0, in: $1)
                }
                
                Observer(context.$fraction, cache: context.fractionLimits) {
                    Intervalizer("Fraction digits",  interval: $0, in: $1)
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