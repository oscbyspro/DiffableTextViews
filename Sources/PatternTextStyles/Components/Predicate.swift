//
//  Predicate.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-18.
//

import Support

//*============================================================================*
// MARK: * Predicate
//*============================================================================*

public struct Predicate: ExpressibleByArrayLiteral {

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let assertions: [(Character) -> Bool]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.assertions = []
    }
    
    @inlinable init(_ assertion: @escaping (Character) -> Bool) {
        self.assertions = [assertion]
    }
    
    @inlinable init(_ assertions: [(Character) -> Bool]) {
        self.assertions = assertions
    }

    @inlinable public init(arrayLiteral elements: ((Character) -> Bool)...) {
        self.assertions = elements
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ character: Character) throws {
        for (index, assertion) in assertions.enumerated() {
            guard assertion(character) else {
                throw Info([.mark(character), "does not satisfy predicate", .mark(index)])
            }
        }
    }
}
