//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * Storageable
//*============================================================================*

@usableFromInline protocol Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    @inlinable var storage: Storage { get }
}

//=----------------------------------------------------------------------------=
// MARK: Storageable - Details
//=----------------------------------------------------------------------------=

extension Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    @inlinable var values: Binding<(CGFloat, CGFloat)> {
        storage.values
    }
    
    @inlinable var valuesLimits: ClosedRange<CGFloat> {
        storage.valuesLimits
    }
}
