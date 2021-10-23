//
//  Offset16.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: Offset16

#warning("Come back to this.")
/// A reminder that UITextField uses UTF16-based offsets.
@usableFromInline struct Offset16: Comparable {
    
    // MARK: Properties
    
    @usableFromInline let wrapped: Int
    
    // MARK: Initializers
    
    @inlinable init(_ wrapped: Int) {
        self.wrapped = wrapped
    }
    
    // MARK: Comparable
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.wrapped < rhs.wrapped
    }
}
