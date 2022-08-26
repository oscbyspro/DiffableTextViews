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
import UIKit

//*============================================================================*
// MARK: * Environment x Toolbar Done Button [...]
//*============================================================================*

@usableFromInline enum DiffableTextViews_ToolbarDoneButton: EnvironmentKey {
    @usableFromInline static let defaultValue: UIBarButtonItem.Style? = nil
}

extension EnvironmentValues {
    @inlinable var diffableTextViews_toolbarDoneButton: UIBarButtonItem.Style? {
        get { self[DiffableTextViews_ToolbarDoneButton.self] }
        set { self[DiffableTextViews_ToolbarDoneButton.self] = newValue }
    }
}

public extension View {
    @inlinable func diffableTextViews_toolbarDoneButton(_  style: UIBarButtonItem.Style = .plain) -> some View  {
        environment(\.diffableTextViews_toolbarDoneButton, style)
    }
}

#endif
