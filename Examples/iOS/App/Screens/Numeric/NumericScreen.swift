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
import NumericTextStyles

//*============================================================================*
// MARK: * NumericScreen
//*============================================================================*

struct NumericScreen: View {
    typealias ScreenContext = NumericScreenContext
    typealias Value = Decimal
    
    //=------------------------------------------------------------------------=
    // MARK: Static
    //=------------------------------------------------------------------------=
    
    private static let exponentsLimit = Value.precision.value
    private static let exponentsLimits = Interval((-exponentsLimit, exponentsLimit))
    private static let integerLimits = Interval((1, Value.precision.integer))
    private static let fractionLimits = Interval((0, Value.precision.fraction))

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @EnvironmentObject private var context: Context
    @StateObject private var screen = NumericScreenContext()
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            controls
            Divider()
            examples
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Controls
    //=------------------------------------------------------------------------=
    
    var controls: some View {
        Scroller {
            diffableTextStyles
            customizationWheels
            boundsIntervalSliders
            integerIntervalSliders
            fractionIntervalSliders
            Spacer()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Controls - Components
    //=------------------------------------------------------------------------=

    var diffableTextStyles: some View {
        Segments(screen.kind.binding)
    }
    
    var customizationWheels: some View {
        NumericScreenWheels(screen.kind.value, locale: screen.locale.binding, currency: screen.currency.binding)
    }
    
    var boundsIntervalSliders: some View {
        NumericScreenSliders("Bounds length (9s)", values: screen.bounds, in: ScreenContext.boundsLimits)
    }
    
    var integerIntervalSliders: some View {
        NumericScreenSliders("Integer digits length", values: screen.integer, in: ScreenContext.integerLimits)
    }
    
    var fractionIntervalSliders: some View {
        NumericScreenSliders("Integer digits length", values: screen.fraction, in: ScreenContext.fractionLimits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Example
    //=------------------------------------------------------------------------=
    
    var examples: some View {
        NumericScreenExamples(screen)
    }
}

//*============================================================================*
// MARK: * NumericScreen x Previews
//*============================================================================*

struct NumericTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        NumericScreen()
            .environmentObject(Context())
            .preferredColorScheme(.dark)
    }
}
