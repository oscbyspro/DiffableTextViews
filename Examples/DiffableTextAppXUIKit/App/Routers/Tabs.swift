//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * Tabs
//*============================================================================*

struct Tabs: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject private var tab = Source(Tab.numeric)
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        TabView(selection: tab.binding) {
            NumericScreen().modifier(Tab.numeric)
            PatternScreen().modifier(Tab.pattern)
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
            content.tag(self).tabItem(label)
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
// MARK: * Tabs x Previews
//*============================================================================*

struct DiffableTextStyleTabsPreviews: PreviewProvider {
    static var previews: some View {
        Tabs()
            .environmentObject(Storage())
            .preferredColorScheme(.dark)
    }
}
