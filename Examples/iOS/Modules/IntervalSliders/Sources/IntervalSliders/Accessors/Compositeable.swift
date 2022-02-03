//
//  Compositeable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

//*============================================================================*
// MARK: * Compositeable
//*============================================================================*

@usableFromInline protocol Compositeable: Layoutable, Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Composite
    //=------------------------------------------------------------------------=
    
    var composite: Composite { get }
}

//=----------------------------------------------------------------------------=
// MARK: Compositeable - Details
//=----------------------------------------------------------------------------=

extension Compositeable {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var layout: Layout {
        composite.layout
    }
    
    @inlinable var storage: Storage {
        composite.storage
    }
}
