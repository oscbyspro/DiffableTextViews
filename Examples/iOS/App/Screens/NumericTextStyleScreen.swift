//
//  NumericTextStyleScreen.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-30.
//

import SwiftUI
import Foundation
import IntervalSliders
import DiffableTextViews
import NumericTextStyles

//*============================================================================*
// MARK: * NumericTextStyleScreen
//*============================================================================*

#warning("Style and local choice should always be there, rest depends on style.")
struct NumericTextStyleScreen: View {
    typealias Value = Double
    
    //=------------------------------------------------------------------------=
    // MARK: Static
    //=------------------------------------------------------------------------=
    
    private static let bounds   = Interval((1, Value.precision.value))
    private static let integer  = Interval((1, Value.precision.integer))
    private static let fraction = Interval((0, Value.precision.fraction))
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State private var value  = Value()
    @State private var style  = Style.number
    @State private var locale = Locale(identifier: "en_US")
    
    //=------------------------------------------------------------------------=
    // MARK: State - Customization
    //=------------------------------------------------------------------------=
    
    @State private var bounds   = Self.bounds
    @State private var integer  = Self.integer
    @State private var fraction = Self.fraction
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            diffableTextStyles
            boundsIntervalSliders
            integerIntervalSliders
            fractionIntervalSliders
            Spacer()
            diffableTextViewsExample
        }
        .environment(\.locale, locale)
    }
     
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var diffableTextStyles: some View {
        Choices(Style.allCases, selection: $style, content: \.label)
    }
    
    var boundsIntervalSliders: some View {
        Sliders(title: "Bounds", interval: $bounds, limits: Self.bounds).disabled(true)
    }
    
    var integerIntervalSliders: some View {
        Sliders(title: "Integer digits", interval: $integer, limits: Self.integer)

    }
    
    var fractionIntervalSliders: some View {
        Sliders(title: "Fraction digits", interval: $fraction, limits: Self.fraction)
    }
    
    var diffableTextViewsExample: some View {
        Example($value) {
            .number
            .bounds((0 as Value)...)
            .precision(integer: integer.closed, fraction: fraction.closed)
        }
    }
    
    //*========================================================================*
    // MARK: * Style
    //*========================================================================*
    
    enum Style: String, CaseIterable {
        
        //=--------------------------------------------------------------------=
        // MARK: Instances
        //=--------------------------------------------------------------------=
        
        case number
        case currency
        case percent
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        var label: some View {
            Text(rawValue.capitalized).tag(self)
        }
    }
}

//*============================================================================*
// MARK: * NumericTextStyleScreen x Previews
//*============================================================================*

struct NumericTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        NumericTextStyleScreen()
            .preferredColorScheme(.dark)
    }
}

