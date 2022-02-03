//
//  Storageable.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
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
    
    @inlinable var limits: ClosedRange<CGFloat> {
        storage.limits
    }
    
    @inlinable var values: Binding<(CGFloat, CGFloat)> {
        storage.values
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @inlinable var radius: CGFloat {
        27
    }
    
    @inlinable var thickness: CGFloat {
        04
    }
    
    @inlinable var coordinates: UInt8 {
        33
    }
    
    @inlinable var animation: Animation {
        Animation.linear(duration: 0.125)
    }
}
