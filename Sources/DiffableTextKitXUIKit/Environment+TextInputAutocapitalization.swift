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
// MARK: * Environment x Text Input Autocapitalization [...]
//*============================================================================*

@usableFromInline enum DiffableTextViews_TextInputAutocapitalization: EnvironmentKey {
    @usableFromInline static let defaultValue: UITextAutocapitalizationType? = nil
}

extension EnvironmentValues {
    @inlinable var diffableTextViews_textInputAutocapitalization: UITextAutocapitalizationType? {
        get { self[DiffableTextViews_TextInputAutocapitalization.self] }
        set { self[DiffableTextViews_TextInputAutocapitalization.self] = newValue }
    }
}

public extension View {
    @inlinable func diffableTextViews_textInputAutocapitalization(
    _ autocapitalization: UITextAutocapitalizationType?) -> some View {
        environment(\.diffableTextViews_textInputAutocapitalization, autocapitalization)
    }
}

#endif
