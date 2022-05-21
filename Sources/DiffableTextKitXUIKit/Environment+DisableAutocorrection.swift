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
// MARK: * Environment x Disable Autocorrection
//*============================================================================*
// MARK: + Key
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_DisableAutocorrection: EnvironmentKey {
    
    //=------------------------------------------------------------------------=
    // MARK: Defaults
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let defaultValue: Bool? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var diffableTextViews_disableAutocorrection: Bool? {
        get { self[DiffableTextViews_DisableAutocorrection.self] }
        set { self[DiffableTextViews_DisableAutocorrection.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func diffableTextViews_disableAutocorrection(_  disable: Bool?) -> some View {
        environment(\.diffableTextViews_disableAutocorrection, disable)
    }
}

#endif
