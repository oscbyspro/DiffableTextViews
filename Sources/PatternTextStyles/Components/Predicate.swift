//
//  Predicate.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

//*============================================================================*
// MARK: * Predicate
//*============================================================================*

public struct Predicate: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let value: AnyHashable
    @usableFromInline let check: (Character) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(value: AnyHashable, check: @escaping (Character) -> Bool) {
        self.value = value
        self.check = check
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable public static func constant(_ check: @escaping (Character) -> Bool = { _ in true }) -> Self {
        Self(value: 0, check: check)
    }
    
    @inlinable public static func variable<ID: Hashable>(value: ID, check: @escaping (Character) -> Bool) -> Self {
        Self(value: value, check: check)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}
