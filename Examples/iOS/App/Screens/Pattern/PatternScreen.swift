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
    
    @State private var value = String()
    @State private var style = Style.phone

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
            Spacer()
        }
    }
    
    var diffableTextStyles: some View {
        Options($style)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Examples
    //=------------------------------------------------------------------------=
    
    var examples: some View {
        Example($value, style: Self.phoneNumberStyle)
            .diffableTextField_onSetup {
                proxy in
                proxy.keyboard(.phonePad)
            }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Caches
    //=------------------------------------------------------------------------=
    
    static let phoneNumberStyle = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .constant()
        .storable()
    
    //*========================================================================*
    // MARK: * Pattern
    //*========================================================================*
    
    enum Style: String, CaseIterable { case phone, card }
}

//*============================================================================*
// MARK: * PatternScreen x Previews
//*============================================================================*

struct PatternTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        PatternScreen().preferredColorScheme(.dark)
    }
}
