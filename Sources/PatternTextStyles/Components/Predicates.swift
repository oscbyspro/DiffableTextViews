//
//  Predicates.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

import Utilities

//*============================================================================*
// MARK: * Predicates
//*============================================================================*

@usableFromInline struct Predicates<Value: Collection> where Value.Element == Character {
    @usableFromInline typealias Predicate = PatternTextStyles.Predicate<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var predicates: [Predicate]
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.predicates = []
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ predicate: Predicate) {
        predicates.append(predicate)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ characters: Value) throws {
        for (index, predicate) in predicates.enumerated() {
            guard predicate.validate(characters) else {
                throw Info([.mark(characters), "does not satisfy predicate", .mark(index)])
            }
        }
    }
}
