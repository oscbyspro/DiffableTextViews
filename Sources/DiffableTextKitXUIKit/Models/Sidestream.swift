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
// MARK: * Sidestream [...]
//*============================================================================*
    
@usableFromInline struct Sidestream {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline var onSubmit: Trigger?

    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    @inlinable init(_ environment: EnvironmentValues) {
        self.onSubmit = environment.diffableTextViews_onSubmit
    }
}

#endif
