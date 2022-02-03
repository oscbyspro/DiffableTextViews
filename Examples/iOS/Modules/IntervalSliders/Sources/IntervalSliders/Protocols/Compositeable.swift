//
//  Compositeable.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//

import SwiftUI

//*============================================================================*
// MARK: * Compositeable
//*============================================================================*

@usableFromInline protocol Compositeable: Layoutable, Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    @inlinable var composite: Composite { get }
}

//=------------------------------------------------------------------------=
// MARK: Compositeable - Details
//=------------------------------------------------------------------------=

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
