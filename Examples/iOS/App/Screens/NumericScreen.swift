//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import Foundation
import DiffableTextViews
import NumericTextStyles

//*============================================================================*
// MARK: * NumericScreen
//*============================================================================*

struct NumericScreen: View {
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
    @State private var currency = "USD"

    @EnvironmentObject private var storage: Storage
    
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
            localizationPickerWheel
            boundsIntervalSliders
            integerIntervalSliders
            fractionIntervalSliders
            Spacer()
        }
    }
    
    var diffableTextStyles: some View {
        Choices(Style.allCases, selection: $style, content: \.label)
    }
    
    var boundsIntervalSliders: some View {
        Sliders("Bounds", values: $bounds, limits: Self.bounds.closed).disabled(true)
    }
    
    var integerIntervalSliders: some View {
        Sliders("Integer digits", values: $integer, limits: Self.integer.closed)
    }
    
    var fractionIntervalSliders: some View {
        Sliders("Fraction digits", values: $fraction, limits: Self.fraction.closed)
    }
    
    var localizationPickerWheel: some View {
        Localizer($locale, in: storage.locales)
    }
    
    var diffableTextViewsExample: some View {
        Example($value) {
            .number
            .bounds((0 as Value)...)
            .precision(integer: integer.closed, fraction: fraction.closed)
        }
        .environment(\.locale, locale)
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
// MARK: * NumericScreen x Previews
//*============================================================================*

struct NumericTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        NumericScreen()
            .preferredColorScheme(.dark)
    }
}

