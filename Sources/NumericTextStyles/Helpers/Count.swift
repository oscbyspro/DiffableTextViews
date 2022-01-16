//
//  Count.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

#warning("Rename significant as valuable.")

//*============================================================================*
// MARK: * Count
//*============================================================================*

public struct Count {

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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func upshift(by amount: Int) {
        integer  += amount
        fraction -= max(0, amount)
    }
    
    @inlinable mutating func downshift(by amount: Int) {
        integer  -= max(0, amount)
        fraction += amount
    }
}
