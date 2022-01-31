//
//  Screen.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-30.
//

import SwiftUI

//*============================================================================*
// MARK: * Screen
//*============================================================================*

struct Screen<Content: View>: View {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @ViewBuilder let content: () -> Content
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        ZStack {
            background
            content().padding()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var background: some View {
        Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
    }
}

//*============================================================================*
// MARK: * Screen x Previews
//*============================================================================*

struct ScreenPreviews: PreviewProvider {
    static var previews: some View {
        Screen {
            Rectangle().fill(Material.regular)
        }
        .preferredColorScheme(.dark)
    }
}
