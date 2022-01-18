//
//  Predicates.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-10.
//

//*============================================================================*
// MARK: * Predicates
//*============================================================================*

public struct Predicates {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var predicates: [Predicate]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.predicates = []
    }
    
    @inlinable init(predicates: [Predicate]) {
        self.predicates = predicates
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func insert(_ assertion: Predicate) {
        self.predicates.append(assertion)
    }
    
    @inlinable mutating func insert(_ predicates: [Predicate]) {
        self.predicates.append(contentsOf: predicates)
    }
    
    @inlinable mutating func insert(_ other: Self) {
        self.predicates.append(contentsOf: other.predicates)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ character: Character) -> Bool {
        for predicate in predicates {
            guard predicate.assertion(character) else { return false }
        }
        
        return true
    }
}
