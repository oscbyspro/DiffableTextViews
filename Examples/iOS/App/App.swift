//
//  App.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-31.
//

import SwiftUI

//*============================================================================*
// MARK: * App
//*============================================================================*

@main struct App: SwiftUI.App {
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some Scene {
        WindowGroup {
            DiffableTextStyleTabs()
                .preferredColorScheme(.dark)
        }
    }
}
