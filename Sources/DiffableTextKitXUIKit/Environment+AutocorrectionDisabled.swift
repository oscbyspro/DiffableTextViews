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
// MARK: * Environment x Autocorrection Disabled [...]
//*============================================================================*

@usableFromInline enum DiffableTextViews_AutocorrectionDisabled: EnvironmentKey {
    @usableFromInline static let defaultValue: Bool = false
}

extension EnvironmentValues {
    @inlinable var diffableTextViews_autocorrectionDisabled: Bool {
        get { self[DiffableTextViews_AutocorrectionDisabled.self] }
        set { self[DiffableTextViews_AutocorrectionDisabled.self] = newValue }
    }
}

public extension View {
    @inlinable func diffableTextViews_autocorrectionDisabled(_  disabled: Bool = true) -> some View {
        environment(\.diffableTextViews_autocorrectionDisabled, disabled)
    }
}

#endif
