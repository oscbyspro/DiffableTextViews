//
//  Predicate.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

//*============================================================================*
// MARK: * Predicate
//*============================================================================*

@usableFromInline struct Predicate: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let value: AnyHashable
    @usableFromInline let validate: (Character) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ value: AnyHashable, _ validate: @escaping (Character) -> Bool) {
        self.value = value
        self.validate = validate
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}
