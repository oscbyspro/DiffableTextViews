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
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject var storage = Storage()
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some Scene {
        WindowGroup {
            DiffableTextStyleScreenTabs()
                .environmentObject(storage)
                .preferredColorScheme(.dark)
        }
    }
}
