//
//  Capacity.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

#warning("Rename.")

//*============================================================================*
// MARK: * Capacity
//*============================================================================*

public struct Capacity {
    
    //=------------------------------------------------------------------------=
    // MARK: Instance
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let min = Self(integer: 1, fraction: 0, significant: 1)

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var integer: Int
    @usableFromInline var fraction: Int
    @usableFromInline var significant: Int

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init(integer: Int, fraction: Int, significant: Int) {
        self.integer = integer
        self.fraction = fraction
        self.significant = significant
    }
}
