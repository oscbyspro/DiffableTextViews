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
// MARK: * Environment x Keyboard Type
//*============================================================================*
// MARK: + Key
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_KeyboardType: EnvironmentKey {
    
    //=------------------------------------------------------------------------=
    // MARK: Defaults
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let defaultValue: UIKeyboardType = .default
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var diffableTextViews_keyboardType: UIKeyboardType {
        get { self[DiffableTextViews_KeyboardType.self] }
        set { self[DiffableTextViews_KeyboardType.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func diffableTextViews_keyboardType(_  type: UIKeyboardType) -> some View {
        environment(\.diffableTextViews_keyboardType, type)
    }
}

#endif
