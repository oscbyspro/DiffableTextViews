//
//  Peek.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-01.
//

//*============================================================================*
// MARK: * Peek
//*============================================================================*

@usableFromInline struct Peek {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lhs: Symbol
    @usableFromInline let rhs: Symbol
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(lhs: Symbol?, rhs: Symbol?) {
        self.lhs = lhs ?? .prefix("\0")
        self.rhs = rhs ?? .suffix("\0")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities - Lookable
    //=------------------------------------------------------------------------=
    
    @inlinable func lookable(direction: Direction) -> Bool {
        direction == .forwards ? rhs.prefixing : lhs.suffixing
    }
    
    @inlinable func nonlookable(direction: Direction) -> Bool {
        !lookable(direction: direction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities - Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func directionality() -> Direction? {
        let  forwards = expresses(.prefixing)
        let backwards = expresses(.suffixing)
        
        if forwards == backwards {
            return nil
        }
        
        return forwards ? .forwards : .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func expresses(_ attribute: Attribute) -> Bool {
        lhs.attribute.contains(attribute) && rhs.attribute.contains(attribute)
    }
}
