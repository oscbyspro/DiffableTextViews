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
// MARK: * Environment x Tint
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_Tint: EnvironmentKey {
    @usableFromInline static let defaultValue: Color? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_tint: Color? {
        get { self[DiffableTextViews_Tint.self] }
        set { self[DiffableTextViews_Tint.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets the tint color for diffable text views.
    ///
    /// It is similar to `View/tint(_:)` and affects text selection.
    ///
    /// ```
    /// DiffableTextField("Tinted", value: $value, style: style)
    ///     .diffableTextViews_tint(.gray)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The default value is `Color.accentColor`.
    /// - The `View/tint(_:)` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_tint(_ color: Color?) -> some View {
        self.environment(\.diffableTextViews_tint,  color)
    }
}

#endif
