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
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_KeyboardType: EnvironmentKey {
    @usableFromInline static let defaultValue: UIKeyboardType = .default
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_keyboardType: UIKeyboardType {
        get { self[DiffableTextViews_KeyboardType.self] }
        set { self[DiffableTextViews_KeyboardType.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets the keyboard type for diffable text views.
    ///
    /// It is similar to `View/keyboardType(_:)`.
    ///
    /// ```
    /// TextField("Amount", value: $amount, style: .currency("USD"))
    ///     .keyboardType(.decimalPad)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The default value is `UIKeyboardType.default`.
    /// - The `View/keyboardType(_:)` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_keyboardType(_ type: UIKeyboardType) -> some View {
        self.environment(\.diffableTextViews_keyboardType, type)
    }
}

#endif
