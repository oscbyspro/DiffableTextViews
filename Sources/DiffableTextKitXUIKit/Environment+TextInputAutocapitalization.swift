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
// MARK: * Environment x Text Input Autocapitalization
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_TextInputAutocapitalization: EnvironmentKey {
    @usableFromInline static let defaultValue: UITextAutocapitalizationType? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_textInputAutocapitalization: UITextAutocapitalizationType? {
        get { self[DiffableTextViews_TextInputAutocapitalization.self] }
        set { self[DiffableTextViews_TextInputAutocapitalization.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets how often the shift key in the keyboard is automatically enabled.
    ///
    /// It is similar to `View/textInputAutocapitalization(_:)`.
    ///
    /// ```
    /// DiffableTextField("Username", value: $username, style: .normal)
    ///     .diffableTextViews_textInputAutocapitalization(.never)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The default is `TextInputAutocapitalization.sentences`.
    /// - The `View/textInputAutocapitalization(_:)` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_textInputAutocapitalization(
    _ autocapitalization: UITextAutocapitalizationType?) -> some View {
        self.environment(\.diffableTextViews_textInputAutocapitalization, autocapitalization)
    }
}

#endif
