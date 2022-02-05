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
    typealias Value = Decimal
    
    //=------------------------------------------------------------------------=
    // MARK: Static
    //=------------------------------------------------------------------------=
    
    private static let bounds = Interval((1, Value.precision.value))
    private static let integer = Interval((1, Value.precision.integer))
    private static let fraction = Interval((0, Value.precision.fraction))
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State private var value = 1_000_000 as Value
    @State private var style = Style.currency
    
    @State private var currency = "USD"
    @State private var locale = Locale(identifier: "en_US")
    
    @State private var bounds = Self.bounds
    @State private var integer = Self.integer
    @State private var fraction = Interval((2, 2))

    @EnvironmentObject private var context: Context
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            controls
            Divider()
            diffableTextViewsExample
        }
    }
     
    //=------------------------------------------------------------------------=
    // MARK: Components
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
    // MARK: Subcomponents
    //=------------------------------------------------------------------------=
    
    var diffableTextStyles: some View {
        Options($style)
    }
    
    var customizationWheels: some View {
        NumericScreenWheels(style, locale: $locale, currency: $currency)
    }
    
    var boundsIntervalSliders: some View {
        Sliders("Bounds", values: $bounds, limits: Self.bounds.closed).disabled(true)
    }
    
    var integerIntervalSliders: some View {
        Sliders("Integer digits length", values: $integer, limits: Self.integer.closed)
    }
    
    var fractionIntervalSliders: some View {
        Sliders("Fraction digits length", values: $fraction, limits: Self.fraction.closed)
    }
    
    var diffableTextViewsExample: some View {
        Example($value) {
            .currency(code: currency)
            .bounds((0 as Value)...)
            .precision(integer: integer.closed, fraction: fraction.closed)
        }
        .environment(\.locale, locale)
    }
    
    //*========================================================================*
    // MARK: * Style
    //*========================================================================*
    
    enum Style: String, CaseIterable { case number, currency, percent }
}

//*============================================================================*
// MARK: * NumericScreen x Previews
//*============================================================================*

struct NumericTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        NumericScreen()
            .preferredColorScheme(.dark)
    }
}

