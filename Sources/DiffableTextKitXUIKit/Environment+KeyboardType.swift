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
// MARK: * Environment x Keyboard Type [...]
//*============================================================================*

@usableFromInline enum DiffableTextViews_KeyboardType: EnvironmentKey {
    @usableFromInline static let defaultValue: UIKeyboardType = .default
}

extension EnvironmentValues {
    @inlinable var diffableTextViews_keyboardType: UIKeyboardType {
        get { self[DiffableTextViews_KeyboardType.self] }
        set { self[DiffableTextViews_KeyboardType.self] = newValue }
    }
}

public extension View {
    @inlinable func diffableTextViews_keyboardType(_  type: UIKeyboardType) -> some View {
        environment(\.diffableTextViews_keyboardType, type)
    }
}

#endif
