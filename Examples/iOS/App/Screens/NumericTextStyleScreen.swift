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

#warning("Style and local choice should always be there, rest depends on style.")
struct NumericTextStyleScreen: View {
    typealias Value = Double
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State private var value  = Value()
    @State private var style  = Style.number
    @State private var locale = Locale(identifier: "en_US")
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            diffableTextStyles
            Spacer()
            diffableTextViewsExample
        }
        .environment(\.locale, locale)
    }
     
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var diffableTextStyles: some View {
        Choices(Style.allCases, selection: $style, content: \.label)
    }
    
    var boundsController: some View {
        GroupBox("Bounds") {
            Color.blue.frame(height: 2).padding(.vertical, 4)
        }
    }
    
    var precisionController: some View {
        GroupBox("Precision") {
            Color.blue.frame(height: 2).padding(.vertical, 4)
            Color.blue.frame(height: 2).padding(.vertical, 4)
        }
    }
    
    var diffableTextViewsExample: some View {
        Example($value) {
            .number
            .bounds((0 as Value)...)
            .precision(integer: 1..., fraction: 2...)
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

