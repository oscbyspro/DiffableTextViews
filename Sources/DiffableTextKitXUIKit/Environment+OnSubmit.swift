//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import DiffableTextKit
import SwiftUI

//*============================================================================*
// MARK: * Environment x On Submit [...]
//*============================================================================*

@usableFromInline enum DiffableTextViews_OnSubmit: EnvironmentKey {
    @usableFromInline static let defaultValue: Trigger? = nil
}

extension EnvironmentValues {
    @inlinable var diffableTextViews_onSubmit: Trigger? {
        get { self[DiffableTextViews_OnSubmit.self] }
        set { self[DiffableTextViews_OnSubmit.self] += newValue }
    }
}

public extension View {
    
    /// Adds an action to perform when the user submits a value to this view.
    ///
    /// It is similar to `View/onSubmit(_:)`.
    ///
    /// ```
    /// DiffableTextField("Username", text: $username, style: .normal)
    ///     .onSubmit {
    ///         guard model.validate() else { return }
    ///         model.login()
    ///     }
    /// ```
    ///
    /// **Notes**
    ///
    /// - The action triggers when the user hits the return key.
    /// - The `View/onSubmit(_:)` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_onSubmit(_ action: (() -> Void)?) -> some View {
        self.environment(\.diffableTextViews_onSubmit, action.map(Trigger.init))
    }
}

#endif
