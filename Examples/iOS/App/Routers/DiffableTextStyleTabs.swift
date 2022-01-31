//
//  DiffableTextStyleTabs.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-31.
//

import SwiftUI

//*============================================================================*
// MARK: * DiffableTextStyleTabs
//*============================================================================*

struct DiffableTextStyleTabs: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State private var tab = Tab.numeric
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        TabView(selection: $tab) {
            NumericTextStyleScreen().modifier(Tab.numeric)
            PatternTextStyleScreen().modifier(Tab.pattern)
        }
    }
    
    //*========================================================================*
    // MARK: * Tab
    //*========================================================================*
    
    struct Tab: ViewModifier, Hashable {
        
        //=--------------------------------------------------------------------=
        // MARK: Instances
        //=--------------------------------------------------------------------=
        
        static let numeric = Self(
            title: "Numeric",
            systemImage: "123.rectangle.fill")
        
        static let pattern = Self(
            title: "Pattern",
            systemImage: "checkerboard.rectangle")
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        let title: String
        let systemImage: String
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        func body(content: Content) -> some View {
            content.tag(title).tabItem(label)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Body - Components
        //=--------------------------------------------------------------------=
        
        func label() -> some View {
            Label(title, systemImage: systemImage)
        }
    }
}

//*============================================================================*
// MARK: * DiffableTextStyleTabs x Previews
//*============================================================================*

struct DiffableTextStyleTabsPreviews: PreviewProvider {
    static var previews: some View {
        DiffableTextStyleTabs()
            .preferredColorScheme(.dark)
    }
}
