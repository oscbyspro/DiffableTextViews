//
//  Text.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

#warning("Charactes should be a function, O(1) - O(n), plus other reasons.")

//*============================================================================*
// MARK: * Text
//*============================================================================*

/// A system representation of the conforming object.
@usableFromInline protocol Text {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates an empty instance.
    @inlinable init()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    /// A sytem representation of the instance.
    @inlinable var characters: String { get }    
}
