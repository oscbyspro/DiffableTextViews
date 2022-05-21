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
// MARK: * Environment x Multiline Text Alignment
//*============================================================================*
// MARK: + Key
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_MultilineTextAlignment: EnvironmentKey {
    
    //=------------------------------------------------------------------------=
    // MARK: Defaults
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let defaultValue: TextAlignment = .leading
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var diffableTextViews_multilineTextAlignment: TextAlignment {
        get { self[DiffableTextViews_MultilineTextAlignment.self] }
        set { self[DiffableTextViews_MultilineTextAlignment.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func diffableTextViews_multilineTextAlignment(_  alignment: TextAlignment) -> some View {
        environment(\.diffableTextViews_multilineTextAlignment, alignment)
    }
}

#endif
