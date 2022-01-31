//
//  PatternScreen.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-30.
//

import SwiftUI
import DiffableTextViews
import PatternTextStyles

//*============================================================================*
// MARK: * PatternScreen
//*============================================================================*

struct PatternScreen: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var value = String()
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            DiffableTextField($value) {
                .pattern("+## (###) ###-##-##")
                .placeholder("#") { $0.isASCII && $0.isNumber }
                .constant()
            }
            .diffableTextField_onSetup {
                proxy in
                proxy.keyboard(.phonePad)
            }
        }
    }
}
