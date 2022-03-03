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
// MARK: * PatternScreenExamples
//*============================================================================*

/// An intermediate examples view that observes infrequent changes.
struct PatternScreenExamples: View {
    typealias Style = PatternTextStyle<String>
    typealias Context = PatternScreenContext
    typealias Kind = Context.Kind
    
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    @ObservedObject var kind: Source<Kind>
    @ObservedObject var visible: Source<Bool>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.context = context
        self.kind = context.kind
        self.visible = context.visible
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        PatternScreenExample(context, style: style)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var style: Style {
        var base: Style { switch kind.content {
            case  .card: return Self .card
            case .phone: return Self.phone
        }}; return base.hidden(!visible.content)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    static let phone = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#") { $0.isASCII && $0.isNumber }
    
    static let card = PatternTextStyle<String>
        .pattern("#### #### #### ####")
        .placeholder("#") { $0.isASCII && $0.isNumber }
}
