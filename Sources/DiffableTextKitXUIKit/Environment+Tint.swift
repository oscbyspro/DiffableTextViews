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
// MARK: * Environment x Tint [...]
//*============================================================================*

@usableFromInline enum DiffableTextViews_Tint: EnvironmentKey {
    @usableFromInline static let defaultValue: Color? = nil
}

extension EnvironmentValues {
    @inlinable var diffableTextViews_tint: Color? {
        get { self[DiffableTextViews_Tint.self] }
        set { self[DiffableTextViews_Tint.self] = newValue }
    }
}

public extension View {
    @inlinable func diffableTextViews_tint(_  color: Color?) -> some View {
        environment(\.diffableTextViews_tint, color)
    }
}

#endif
