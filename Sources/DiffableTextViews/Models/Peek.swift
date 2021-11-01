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
    
    // MARK: Descriptions: Lookahead
    
    @inlinable var lookaheadable: Bool {
        rhs.attribute.contains(.prefix)
    }
    
    @inlinable var nonlookaheadable: Bool {
        !lookaheadable
    }
    
    // MARK: Descriptions: Lookbehind
    
    @inlinable var lookbehindable: Bool {
        lhs.attribute.contains(.suffix)
    }
    
    @inlinable var nonlookbehindable: Bool {
        !lookbehindable
    }
    
    // MARK: Descriptions: Preference
    
    @inlinable func lookable(_ direction: Direction) -> Bool {
        direction == .forwards ? lookaheadable : lookbehindable
    }
    
    @inlinable func nonlookable(_ direction: Direction) -> Bool {
        !lookable(direction)
    }
    
    // MARK: Descriptions: Attributes

    @inlinable func containsOnBothSides(_ attribute: Attribute) -> Bool {
        lhs.attribute.contains(attribute) && rhs.attribute.contains(attribute)
    }
        
    @inlinable func directionOfAttributes() -> Direction? {
        let forwards  = containsOnBothSides(.prefix)
        let backwards = containsOnBothSides(.suffix)
        
        if forwards == backwards {
            return nil
        }
        
        return forwards ? .forwards : .backwards
    }
}
