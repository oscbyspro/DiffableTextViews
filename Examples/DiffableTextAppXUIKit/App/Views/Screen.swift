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
// MARK: * Screen
//*============================================================================*

struct Screen<Content: View>: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @ViewBuilder let content: () -> Content
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                content()
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
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
