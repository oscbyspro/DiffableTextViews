//
//  Count.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

import Quick

//*============================================================================*
// MARK: * Count
//*============================================================================*

/// - Value meant as shorthand for significant digits.
public struct Count: Transformable {

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Int
    @usableFromInline var integer: Int
    @usableFromInline var fraction: Int

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init(value: Int, integer: Int, fraction: Int) {
        self.value = value
        self.integer = integer
        self.fraction = fraction
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func upshift(by amount: Int) {
        integer  = max(0, integer  + amount)
        fraction = max(0, fraction - amount)
    }
    
    @inlinable mutating func downshift(by amount: Int) {
        integer  = max(0, integer  - amount)
        fraction = max(0, fraction + amount)
    }
}
