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
    @State private var style = Style.phone

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            diffableTextStyles
            Spacer()
            diffableTextViewsExample
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var diffableTextStyles: some View {
        Choices(Style.allCases, selection: $style, content: \.label)
    }
    
    var diffableTextViewsExample: some View {
        Example($value) {
            .pattern("+## (###) ###-##-##")
            .placeholder("#"  as Character) { $0.isASCII && $0.isNumber }
            .constant()
        }
        .diffableTextField_onSetup {
            proxy in
            proxy.keyboard(.phonePad)
        }
    }
    
    //*========================================================================*
    // MARK: * Pattern
    //*========================================================================*
    
    enum Style: String, CaseIterable {
        
        //=--------------------------------------------------------------------=
        // MARK: Instances
        //=--------------------------------------------------------------------=
        
        case phone
        case card
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        var label: some View {
            Text(rawValue.capitalized).tag(self)
        }
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
