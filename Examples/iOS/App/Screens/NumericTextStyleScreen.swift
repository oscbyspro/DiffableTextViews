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
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @EnvironmentObject private var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State private var number = Decimal()
    @State private var locale = Locale(identifier: "en_US")
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            diffableTextField
        }
        .environment(\.locale, locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var diffableTextField: some View {
        DiffableTextField($number) {
            .number
            .bounds((0 as Decimal)...)
            .precision(integer: 1..., fraction: 2...)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
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

