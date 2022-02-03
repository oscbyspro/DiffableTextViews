//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Layoutable
//*============================================================================*

@usableFromInline protocol Layoutable {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    @inlinable var layout: Layout { get }
}

//=----------------------------------------------------------------------------=
// MARK: Layoutable - Details
//=----------------------------------------------------------------------------=

extension Layoutable {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    @inlinable var frame: CGRect {
        layout.frame
    }
    
    @inlinable var positions: (CGFloat, CGFloat) {
        layout.positions
    }
    
    @inlinable var positionsLimits: ClosedRange<CGFloat> {
        layout.positionsLimits
    }
}

