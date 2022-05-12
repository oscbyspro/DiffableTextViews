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
// MARK: Declaration
//*============================================================================*
    
@usableFromInline struct Actions {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var onSubmit: Trigger?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
     
    @inlinable @inline(__always) init() { }
    
    @inlinable @inline(__always) init(_ environment: EnvironmentValues) {
        self.onSubmit = environment.diffableTextViews_onSubmit
    }
}

#endif
