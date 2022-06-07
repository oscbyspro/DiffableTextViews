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
// MARK: * Environment x Font
//*============================================================================*
// MARK: + Key
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_Font: EnvironmentKey {
    
    //=------------------------------------------------------------------------=
    // MARK: Defaults
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let defaultValue: DiffableTextFont? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var diffableTextViews_font: DiffableTextFont? {
        get { self[DiffableTextViews_Font.self] }
        set { self[DiffableTextViews_Font.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func diffableTextViews_font(_  font: DiffableTextFont?) -> some View {
        environment(\.diffableTextViews_font, font)
    }
}

#endif