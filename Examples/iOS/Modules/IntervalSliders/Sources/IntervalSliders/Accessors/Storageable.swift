//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Storageable
//*============================================================================*

@usableFromInline protocol Storageable: Intervalable, Layoutable {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    @inlinable var storage: Storage { get }
}

//=----------------------------------------------------------------------------=
// MARK: Storageable
//=----------------------------------------------------------------------------=

extension Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var layout: Layout {
        storage.layout
    }
    
    @inlinable var interval: Interval {
        storage.interval
    }
}
