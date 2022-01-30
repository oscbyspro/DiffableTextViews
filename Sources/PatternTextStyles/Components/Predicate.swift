//
//  Predicate.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

import Support

//*============================================================================*
// MARK: * Predicate
//*============================================================================*

@usableFromInline struct Predicate: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let proxy: AnyHashable
    @usableFromInline let check: (Character) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(proxy: AnyHashable, check: @escaping (Character) -> Bool) {
        self.proxy = proxy
        self.check = check
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.proxy == rhs.proxy
    }
}
