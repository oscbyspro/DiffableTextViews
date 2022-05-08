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
    typealias Pattern = Context.PatternID
    typealias Visibility = Context.VisibilityID
    
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    @ObservedObject var pattern: Observable<Pattern>
    @ObservedObject var visibility: Observable<Visibility>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.context = context
        self.pattern = context.pattern
        self.visibility = context.visibility
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var style: Style {
        switch pattern.wrapped {
        case  .card: return Self .card
        case .phone: return Self.phone
        }
    }
    
    var visible: Bool {
        switch visibility.wrapped {
        case .visible: return  true
        case  .hidden: return false
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        PatternScreenExampleX(context, style: style.hidden(!visible))
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
