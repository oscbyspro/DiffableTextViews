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
// MARK: * Environment x Text Content Type [...]
//*============================================================================*

@usableFromInline enum DiffableTextViews_TextContentType: EnvironmentKey {
    @usableFromInline static let defaultValue: UITextContentType? = nil
}

extension EnvironmentValues {
    @inlinable var diffableTextViews_textContentType: UITextContentType? {
        get { self[DiffableTextViews_TextContentType.self] }
        set { self[DiffableTextViews_TextContentType.self] = newValue }
    }
}

public extension View {
    @inlinable func diffableTextViews_textContentType(_  type: UITextContentType?) -> some View {
        environment(\.diffableTextViews_textContentType, type)
    }
}

#endif
