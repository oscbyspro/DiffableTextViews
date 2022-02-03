//
//  ContentTabs.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-31.
//

import SwiftUI

//*============================================================================*
// MARK: * ContentTabs
//*============================================================================*

struct ContentTabs: View {
    
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
        // MARK: State
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
        // MARK: Components
        //=--------------------------------------------------------------------=
        
        func label() -> some View {
            Label(title, systemImage: systemImage)
        }
    }
}

//*============================================================================*
// MARK: * ContentTabs x Previews
//*============================================================================*

struct DiffableTextStyleTabsPreviews: PreviewProvider {
    static var previews: some View {
        ContentTabs()
            .preferredColorScheme(.dark)
    }
}
