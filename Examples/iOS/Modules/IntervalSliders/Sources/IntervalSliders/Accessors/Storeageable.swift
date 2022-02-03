//
//  Storageable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

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
