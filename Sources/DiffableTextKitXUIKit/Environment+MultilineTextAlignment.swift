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
// MARK: * Environment x Multiline Text Alignment
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_MultilineTextAlignment: EnvironmentKey {
    @usableFromInline static let defaultValue: TextAlignment = .leading
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_multilineTextAlignment: TextAlignment {
        get { self[DiffableTextViews_MultilineTextAlignment.self] }
        set { self[DiffableTextViews_MultilineTextAlignment.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets the alignment of text in diffable text views.
    ///
    /// It is similar to `View/multilineTextAlignment(_:)`.
    ///
    /// ```
    /// DiffableTextField("Amount", value: $amount, style: .number)
    ///     .diffableTextViews_multilineTextAlignment(.trailing)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The default value is `TextAlignment.leading`.
    /// - This method was added for consistency.
    ///
    @inlinable func diffableTextViews_multilineTextAlignment(_ alignment: TextAlignment) -> some View {
        self.environment(\.diffableTextViews_multilineTextAlignment, alignment)
    }
}

#endif
