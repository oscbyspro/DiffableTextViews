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
    
    private static let exponentsLimit = Value.precision.value
    private static let exponentsLimits = Interval((-exponentsLimit, exponentsLimit))
    private static let integerLimits = Interval((1, Value.precision.integer))
    private static let fractionLimits = Interval((0, Value.precision.fraction))

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @EnvironmentObject private var context: Context
    
    @State private var value = Decimal(string: "1234567.89")!
    @State private var style = Style.currency
    
    @State private var currencyCode = "USD"
    @State private var locale = Locale(identifier: "en_US")
    
    @State private var integer = Self.integerLimits
    @State private var fraction = Interval((2, 2))
    @State private var exponents = Interval((0, Self.exponentsLimit))
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            controls
            Divider()
            examples
        }
        .environment(\.locale, locale)
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
        Options($style)
    }
    
    var customizationWheels: some View {
        NumericScreenWheels(style, locale: $locale, currency: $currencyCode)
    }
    
    var boundsIntervalSliders: some View {
        Sliders("Bounds length (9s)", values: $exponents, limits: Self.exponentsLimits.closed)
    }
    
    var integerIntervalSliders: some View {
        Sliders("Integer digits length", values: $integer, limits: Self.integerLimits.closed)
    }
    
    var fractionIntervalSliders: some View {
        Sliders("Fraction digits length", values: $fraction, limits: Self.fractionLimits.closed)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Example
    //=------------------------------------------------------------------------=
    
    @ViewBuilder var examples: some View {
        switch style {
        case .number:
            Example($value) {
                .number
                .bounds(bounds)
                .precision(integer: integer.closed, fraction: fraction.closed)
            }
        case .currency:
            Example($value) {
                .currency(code: currencyCode)
                .bounds(bounds)
                .precision(integer: integer.closed, fraction: fraction.closed)
            }
        case .percent:
            Example($value) {
                .percent
                .bounds(bounds)
                .precision(integer: integer.closed, fraction: fraction.closed)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Example - Values
    //=------------------------------------------------------------------------=
    
    var bounds: ClosedRange<Decimal> {
        let ordered = exponents.closed
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        func bound(_ length: Int) -> Decimal {
            guard length != 0 else { return 0 }
            var description = length >= 0 ? "" : "-"
            description += String(repeating: "9", count: abs(length))
            return Decimal(string: description)!
        }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return bound(ordered.lowerBound)...bound(ordered.upperBound)
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
            .environmentObject(Context())
            .preferredColorScheme(.dark)
    }
}
