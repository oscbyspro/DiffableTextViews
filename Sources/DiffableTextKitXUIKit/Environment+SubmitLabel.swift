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
// MARK: * Environment x Submit Label [...]
//*============================================================================*

@usableFromInline enum DiffableTextViews_SubmitLabel: EnvironmentKey {
    @usableFromInline static let defaultValue: UIReturnKeyType = .default
}

extension EnvironmentValues {
    @inlinable var diffableTextViews_submitLabel: UIReturnKeyType {
        get { self[DiffableTextViews_SubmitLabel.self] }
        set { self[DiffableTextViews_SubmitLabel.self] = newValue }
    }
}

public extension View {
    @inlinable func diffableTextViews_submitLabel(_  label: UIReturnKeyType) -> some View {
        environment(\.diffableTextViews_submitLabel, label)
    }
}

#endif
