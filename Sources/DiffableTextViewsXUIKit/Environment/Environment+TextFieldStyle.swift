//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import SwiftUI

//*============================================================================*
// MARK: Environment x Key
//*============================================================================*

@usableFromInline enum DiffableTextViews_TextFieldStyle: EnvironmentKey {
    @usableFromInline static let defaultValue: UITextField.BorderStyle = .none // enum
}

//*============================================================================*
// MARK: Environment x Values
//*============================================================================*

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var diffableTextViews_textFieldStyle: UITextField.BorderStyle {
        get { self[DiffableTextViews_TextFieldStyle.self] }
        set { self[DiffableTextViews_TextFieldStyle.self] = newValue }
    }
}

//*============================================================================*
// MARK: Environment x View
//*============================================================================*

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func diffableTextViews_textFieldStyle(_  style: UITextField.BorderStyle) -> some View {
        environment(\.diffableTextViews_textFieldStyle, style)
    }
}

#endif
