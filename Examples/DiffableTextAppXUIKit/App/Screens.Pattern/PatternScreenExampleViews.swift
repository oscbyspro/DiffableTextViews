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

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// An intermediate examples view that observes infrequent changes.
struct PatternScreenExample: View {
    typealias Style = PatternTextStyle<String>
    typealias Context = PatternScreenContext
    typealias Kind = Context.Kind
    
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    @ObservedObject var kind: Observable<Kind>
    @ObservedObject var visible: Observable<Bool>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.context = context
        self.kind = context.kind
        self.visible = context.visible
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var style: Style {
        switch kind.wrapped {
        case  .card: return Self .card
        case .phone: return Self.phone
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        PatternScreenExampleX(context, style: style.hidden(!visible.wrapped))
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

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// An examples view that observes frequent changes.
struct PatternScreenExampleX<Style: DiffableTextStyle>: View where Style.Value == String {
    typealias Context = PatternScreenContext
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let style: Style
    @ObservedObject var value: Observable<String>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context, style: Style) {
        self.style = style
        self.value = context.value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Example(value.xwrapped, style: style).diffableTextViews_keyboardType(.numberPad)
    }
}
