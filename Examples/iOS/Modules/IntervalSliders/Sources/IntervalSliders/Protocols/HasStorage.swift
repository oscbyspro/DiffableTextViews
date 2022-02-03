//
//  HasStorage.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//

import SwiftUI

//*============================================================================*
// MARK: * HasStorage
//*============================================================================*

@usableFromInline protocol HasStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    @inlinable var storage: Storage { get }
}

//=----------------------------------------------------------------------------=
// MARK: HasStorage - Details
//=----------------------------------------------------------------------------=

extension HasStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var limits: ClosedRange<CGFloat> {
        storage.limits
    }
    
    @inlinable var values: Binding<(CGFloat, CGFloat)> {
        storage.values
    }
}
