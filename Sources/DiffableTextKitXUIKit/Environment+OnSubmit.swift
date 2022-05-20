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
// MARK: Environment x Key
//*============================================================================*

@usableFromInline enum DiffableTextViews_OnSubmit: EnvironmentKey {
    @usableFromInline static let defaultValue: Trigger? = nil
}

//*============================================================================*
// MARK: Environment x Values
//*============================================================================*

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var diffableTextViews_onSubmit: Trigger? {
        get { self[DiffableTextViews_OnSubmit.self] }
        set { self[DiffableTextViews_OnSubmit.self] += newValue }
    }
}

//*============================================================================*
// MARK: Environment x View
//*============================================================================*

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Adds an action to perform when the user submits a value to this view.
    ///
    /// DiffableTextViews trigger this action when the user hits the return key.
    ///
    @inlinable func diffableTextViews_onSubmit(_  action: (() -> Void)?) -> some View {
        environment(\.diffableTextViews_onSubmit, action.map(Trigger.init))
    }
}

#endif
