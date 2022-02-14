//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import DiffableTextViews
import PatternTextStyles

//*============================================================================*
// MARK: * PatternScreen
//*============================================================================*

struct PatternScreen: View {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject var screen = PatternScreenContext()

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            controls
            Divider()
            examples
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Controls
    //=------------------------------------------------------------------------=

    var controls: some View {
        Scroller {
            diffableTextStyles
            hiddenToggleSwitch
            Spacer()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Controls - Components
    //=------------------------------------------------------------------------=
    
    var diffableTextStyles: some View {
        Segments(screen.pattern.binding)
    }
    
    var hiddenToggleSwitch: some View {
        PatternScreenVisibility(visible: screen.visible)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Examples
    //=------------------------------------------------------------------------=
    
    var examples: some View {
        PatternScreenExample(value: screen.value, pattern: screen.pattern, visible: screen.visible)
    }
}

//*============================================================================*
// MARK: * PatternScreen x Previews
//*============================================================================*

struct PatternTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        PatternScreen().preferredColorScheme(.dark)
    }
}
