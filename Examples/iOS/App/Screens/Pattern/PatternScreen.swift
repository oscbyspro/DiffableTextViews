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
    typealias Context = PatternScreenContext

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject var context = Context()

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
            actions
            Spacer()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Controls - Components
    //=------------------------------------------------------------------------=
    
    var diffableTextStyles: some View {
        Segments(context.kind.binding)
    }
    
    var hiddenToggleSwitch: some View {
        PatternScreenVisibility(visible: context.visible)
    }
    
    var actions: some View {
        PatternScreenActions(context)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Examples
    //=------------------------------------------------------------------------=
    
    var examples: some View {
        PatternScreenExamples(context)
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
