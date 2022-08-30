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
// MARK: * Environment x Foreground Color
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_ForegroundColor: EnvironmentKey {
    @usableFromInline static let defaultValue: Color? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_foregroundColor: Color? {
        get { self[DiffableTextViews_ForegroundColor.self] }
        set { self[DiffableTextViews_ForegroundColor.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets the text color of diffable text views.
    ///
    /// It is similar to `View/foregroundColor(_:)`.
    ///
    /// ```
    /// DiffableTextField("Amount", value: $amount, style: .number)
    ///     .diffableTextViews_foregroundColor(amount > 100 ? .red : nil)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The default value is `Color.primary`.
    /// - The `View/foregroundColor(_:)` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_foregroundColor(_ color: Color?) -> some View {
        self.environment(\.diffableTextViews_foregroundColor,  color)
    }
}

#endif
