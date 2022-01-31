//
//  PatternTextStyleScreen.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-30.
//

import SwiftUI
import DiffableTextViews
import PatternTextStyles

//*============================================================================*
// MARK: * PatternTextStyleScreen
//*============================================================================*

struct PatternTextStyleScreen: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State private var content = String()
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            DiffableTextField($content) {
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
