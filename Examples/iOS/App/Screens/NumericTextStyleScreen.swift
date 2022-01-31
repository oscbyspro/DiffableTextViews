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
            VStack {
                picker
                Spacer()
                diffableTextField
                Spacer()
            }
        }
        .environment(\.locale, locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var picker: some View {
        Picker("Style", selection: $style) {
            Text("A").tag(Style.number)
            Text("B").tag(Style.currency)
            Text("C").tag(Style.percent)
        }
        .pickerStyle(.segmented)
    }
    
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
    
    #warning("TODO.")
    enum Style { case number, currency, percent }
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

