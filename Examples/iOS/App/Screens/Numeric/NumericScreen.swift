//
//  NumericScreen.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-30.
//

import SwiftUI
import Foundation
import DiffableTextViews
import NumericTextStyles

//*============================================================================*
// MARK: * NumericScreen
//*============================================================================*

struct NumericScreen: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var value = Decimal()
    @State var locale = Locale(identifier: "en_US")
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            DiffableTextField($value) {
                .number
                .bounds((0 as Decimal)...)
                .precision(integer: 1..., fraction: 2...)
            }
            .environment(\.locale, locale)
        }
    }
}
