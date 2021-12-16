//
//  Peek.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-01.
//

// MARK: - Peek

@usableFromInline struct Peek {
    
    // MARK: Properties
    
    @usableFromInline let lhs: Symbol
    @usableFromInline let rhs: Symbol
    
    // MARK: Initializers
    
    @inlinable init(lhs: Symbol?, rhs: Symbol?) {
        self.lhs = lhs ?? .prefix("\0")
        self.rhs = rhs ?? .suffix("\0")
    }
    
    // MARK: Descriptions: Lookable
    
    @inlinable var lookaheadable: Bool {
        rhs.attribute.contains(.prefixing)
    }
    
    @inlinable var nonlookaheadable: Bool {
        !lookaheadable
    }
        
    @inlinable var lookbehindable: Bool {
        lhs.attribute.contains(.suffixing)
    }
    
    @inlinable var nonlookbehindable: Bool {
        !lookbehindable
    }
        
    @inlinable func lookable(_ direction: Direction) -> Bool {
        direction == .forwards ? lookaheadable : lookbehindable
    }
    
    @inlinable func nonlookable(_ direction: Direction) -> Bool {
        !lookable(direction)
    }
    
    // MARK: Descriptions: Attributes
        
    @inlinable func directionOfAttributes() -> Direction? {
        let forwards  = containsOnBothSides(.prefixing)
        let backwards = containsOnBothSides(.suffixing)
        
        if forwards == backwards {
            return nil
        }
        
        return forwards ? .forwards : .backwards
    }
        
    @inlinable func containsOnBothSides(_ attribute: Attribute) -> Bool {
        lhs.attribute.contains(attribute) && rhs.attribute.contains(attribute)
    }
}
