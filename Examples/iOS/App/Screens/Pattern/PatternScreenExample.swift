//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import PatternTextStyles

//*============================================================================*
// MARK: * PatternScreenExample
//*============================================================================*

struct PatternScreenExample: View {
    typealias Pattern = PatternScreenContext.Pattern
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @ObservedObject var value:   Source<String>
    @ObservedObject var pattern: Source<Pattern>
    @ObservedObject var visible: Source<Bool>
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Example(value.binding, style: style)
            .diffableTextField_onSetup {
                proxy in
                proxy.keyboard(.numberPad)
            }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var style: PatternTextStyle<String>.Reference.Equals<[AnyHashable]> {
        var result: PatternTextStyle<String>.Reference
        
        switch pattern.value {
        case .card: result = Self.cardNumberStyle
        case .phone: result = Self.phoneNumberStyle
        }
        
        result.style = result.style.hidden(!visible.value)
        return result.equals([pattern.value, visible.value])
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
}
