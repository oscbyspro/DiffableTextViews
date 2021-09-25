//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#warning("Should Caret have an index/position property?")

@usableFromInline struct Caret {
    @usableFromInline let lhs: Symbol
    @usableFromInline let rhs: Symbol
    
    // MARK: Initializers
    
    @inlinable init(lhs: Symbol?, rhs: Symbol?) {
        self.lhs = lhs ?? .prefix("<")
        self.rhs = rhs ?? .suffix(">")
    }
}
