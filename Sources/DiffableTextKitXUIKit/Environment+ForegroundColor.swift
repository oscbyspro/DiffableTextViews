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
// MARK: * Environment x Foreground Color
//*============================================================================*
// MARK: + Key
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_ForegroundColor: EnvironmentKey {
    
    //=------------------------------------------------------------------------=
    // MARK: Defaults
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let defaultValue: Color? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var diffableTextViews_foregroundColor: Color? {
        get { self[DiffableTextViews_ForegroundColor.self] }
        set { self[DiffableTextViews_ForegroundColor.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func diffableTextViews_foregroundColor(_  color: Color?) -> some View {
        environment(\.diffableTextViews_foregroundColor, color)
    }
}

#endif
