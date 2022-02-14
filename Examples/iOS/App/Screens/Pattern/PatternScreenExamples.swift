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
    
    var style: Style.Reference.Equals<[AnyHashable]> {
        var reference: Style.Reference
        //=--------------------------------------=
        // MARK: Match
        //=--------------------------------------=
        switch kind.value {
        case .card: reference = Self.card
        case .phone: reference = Self.phone
        }
        //=--------------------------------------=
        // MARK: Setup
        //=--------------------------------------=
        reference.style = reference.style.hidden(!visible.value)
        return reference.equals([kind.value, visible.value])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    static let phone = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .reference()
    
    static let card = PatternTextStyle<String>
        .pattern("#### #### #### ####")
        .placeholder("#" as Character) { $0.isASCII && $0.isNumber }
        .reference()
}
