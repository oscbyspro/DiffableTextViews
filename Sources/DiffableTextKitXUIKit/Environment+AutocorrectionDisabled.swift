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
// MARK: * Environment x Autocorrection Disabled
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_AutocorrectionDisabled: EnvironmentKey {
    @usableFromInline static let defaultValue: Bool = false
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_autocorrectionDisabled: Bool {
        get { self[DiffableTextViews_AutocorrectionDisabled.self] }
        set { self[DiffableTextViews_AutocorrectionDisabled.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets whether to disable autocorrection for diffable text views.
    ///
    /// It is similar to `View/autocorrectionDisabled(_:)`.
    ///
    /// ```
    /// DiffableTextField("Text", value: $text, style: .normal)
    ///     .diffableTextViews_autocorrectionDisabled(true)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The default value is `false`.
    /// - This method was added for consistency.
    ///
    @inlinable func diffableTextViews_autocorrectionDisabled(_ disabled: Bool = true) -> some View {
        self.environment(\.diffableTextViews_autocorrectionDisabled, disabled)
    }
}

#endif
