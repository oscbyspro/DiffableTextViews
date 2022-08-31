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
// MARK: * Environment x Toolbar Done Button
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_ToolbarDoneButton: EnvironmentKey {
    @usableFromInline static let defaultValue: UIBarButtonItem.Style? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_toolbarDoneButton: UIBarButtonItem.Style? {
        get { self[DiffableTextViews_ToolbarDoneButton.self] }
        set { self[DiffableTextViews_ToolbarDoneButton.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Adds a toolbar with a done button for convenient dismissal.
    ///
    /// Instructs the view to install a toolbar similar to SwiftUI's
    ///
    /// ```
    /// .toolbar {
    ///     ToolbarItemGroup(placement: .keyboard) {
    ///         Spacer()
    ///         Button("Done") {
    ///             // UIResponder/resignFirstResponder()
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// **Notes**
    ///
    /// - The value is read when the view is set up.
    /// - The default value is `nil` (no toolbar installed).
    /// - The `View/toolbar(_:)` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_toolbarDoneButton(_ style: UIBarButtonItem.Style = .plain) -> some View {
        self.environment(\.diffableTextViews_toolbarDoneButton, style)
    }
}

#endif
