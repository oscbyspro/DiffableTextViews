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
    
    @State private var value = String()
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            VStack {
                Spacer()
                Description(value)
                diffableTextField
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    #warning("Duplicate: almost.")
    var diffableTextField: some View {
        DiffableTextField($value) {
            .pattern("+## (###) ###-##-##")
            .placeholder("#"  as Character) { $0.isASCII && $0.isNumber }
            .constant()
        }
        .diffableTextField_onSetup {
            proxy in
            proxy.keyboard(.phonePad)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
    }
}

//*============================================================================*
// MARK: * PatternTextStyleScreen x Previews
//*============================================================================*

struct PatternTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        PatternTextStyleScreen()
            .preferredColorScheme(.dark)
    }
}
