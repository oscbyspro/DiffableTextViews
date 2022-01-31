//
//  NumericTextStyleScreen.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-30.
//

import SwiftUI
import Foundation
import DiffableTextViews
import NumericTextStyles

//*============================================================================*
// MARK: * NumericTextStyleScreen
//*============================================================================*

struct NumericTextStyleScreen: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State private var value  = Decimal()
    @State private var style  = Style.number
    @State private var locale = Locale(identifier: "en_US")
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            diffableTextStylePicker
            Spacer()
            Description(value)
            diffableTextField
        }
        .environment(\.locale, locale)
    }
     
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var diffableTextStylePicker: some View {
        Picker("Style", selection: $style) {
            Style.number
            Style.currency
            Style.percent
        }
        .pickerStyle(.segmented)
    }
    
    #warning("Duplicate: almost.")
    var diffableTextField: some View {
        DiffableTextField($value) {
            .number
            .bounds((0 as Decimal)...)
            .precision(integer: 1..., fraction: 2...)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
    }
    
    //*========================================================================*
    // MARK: * Style
    //*========================================================================*
    
    enum Style: String, View {
        
        //=--------------------------------------------------------------------=
        // MARK: Instances
        //=--------------------------------------------------------------------=
        
        case number
        case currency
        case percent
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        var body: some View {
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

