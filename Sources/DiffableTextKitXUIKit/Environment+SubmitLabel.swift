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
// MARK: * Environment x Submit Label
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_SubmitLabel: EnvironmentKey {
    @usableFromInline static let defaultValue: UIReturnKeyType = .default
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_submitLabel: UIReturnKeyType {
        get { self[DiffableTextViews_SubmitLabel.self] }
        set { self[DiffableTextViews_SubmitLabel.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets the submit label for diffable text views.
    ///
    /// It is similar to `View/submitLabel(_:)`.
    ///
    /// ```
    /// DiffableTextField("Prints on submit...", value: $value, style: style)
    ///     .diffableTextViews_submitLabel(.return)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The default value is `UIReturnKeyType.default`.
    /// - The `View/submitLabel(_:)` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_submitLabel(_ label: UIReturnKeyType) -> some View {
        self.environment(\.diffableTextViews_submitLabel, label)
    }
}

#endif
