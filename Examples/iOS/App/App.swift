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
    var body: some Scene {
        WindowGroup {
            NumericScreen()
                .preferredColorScheme(.dark)
        }
    }
}
