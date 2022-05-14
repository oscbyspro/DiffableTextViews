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
// MARK: Declaration
//*============================================================================*

struct Tabs: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject private var tab = Observable(Tab.numeric)
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        TabView(selection: tab.xstorage) {
            NumberScreen() .modifier(Tab.numeric)
            PatternScreen().modifier(Tab.pattern)
        }
    }
    
    //*========================================================================*
    // MARK: Tab
    //*========================================================================*
    
    struct Tab: ViewModifier, Hashable {
        
        //=--------------------------------------------------------------------=
        // MARK: Instances
        //=--------------------------------------------------------------------=
        
        static let numeric = Self(
            title: "Number",
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
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        func label() -> some View {
            Label(title, systemImage: systemImage)
        }
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Tabs_Previews: PreviewProvider {
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        Tabs().preferredColorScheme(.dark)
    }
}
