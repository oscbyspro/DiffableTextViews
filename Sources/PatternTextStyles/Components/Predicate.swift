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
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    public static let ASCIIDigit = Self([{ $0.isASCII && $0.isNumber }])

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

    @inlinable init(_ assertions: [(Character) -> Bool]) {
        self.assertions = assertions
    }

    @inlinable public init(arrayLiteral assertions: (Character) -> Bool...) {
        self.assertions = assertions
    }

    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ character: Character) throws {
        for assertion in assertions {
            guard assertion(character) else {
                throw Info([.mark(character), "is invalid."])
            }
        }
    }
}
