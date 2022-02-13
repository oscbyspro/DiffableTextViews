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
    
    @State private var value = "12000345"
    @State private var style = Style.phone
    @State private var visible: Bool = true

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
        Options($style)
    }
    
    var hiddenToggleSwitch: some View {
        Toggle(isOn: $visible) {
            Text(visible ? "Visible" : "Hidden")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .contentShape(Rectangle())
        }
        .background(Color.gray.opacity(0.125))
        .background(Material.ultraThick)
        .toggleStyle(.button)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Examples
    //=------------------------------------------------------------------------=
    
    var examples: some View {
        Example($value, style: pattern)
            .diffableTextField_onSetup {
                proxy in
                proxy.keyboard(.numberPad)
            }
    }
    
    var pattern: PatternTextStyle<String>.Reference.Equals<[AnyHashable]> {
        var pattern: PatternTextStyle<String>.Reference
        
        switch style {
        case .card: pattern = Self.cardNumberStyle
        case .phone: pattern = Self.phoneNumberStyle
        }
        
        pattern.style = pattern.style.hidden(!visible)
        return pattern.equals([style, visible])
    }

    //=------------------------------------------------------------------------=
    // MARK: Caches
    //=------------------------------------------------------------------------=
    
    static let phoneNumberStyle = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .reference()
    
    static let cardNumberStyle = PatternTextStyle<String>
        .pattern("#### #### #### ####")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .reference()
    
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
