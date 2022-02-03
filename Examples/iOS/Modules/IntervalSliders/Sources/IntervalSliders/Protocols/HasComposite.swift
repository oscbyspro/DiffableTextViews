//
//  HasComposite.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//

import SwiftUI

//*============================================================================*
// MARK: * HasComposite
//*============================================================================*

@usableFromInline protocol HasComposite: HasLayout, HasStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    @inlinable var composite: Composite { get }
}

//=------------------------------------------------------------------------=
// MARK: HasComposite - Details
//=------------------------------------------------------------------------=

extension HasComposite {
    
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
