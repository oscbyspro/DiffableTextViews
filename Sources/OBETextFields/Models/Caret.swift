//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline
struct Caret: Equatable {
    @usableFromInline let lhs: Symbol
    @usableFromInline let rhs: Symbol
    
    // MARK: Initializers
    
    @inlinable init(lhs: Symbol?, rhs: Symbol?) {
        self.lhs = lhs ?? .prefix("<")
        self.rhs = rhs ?? .suffix(">")
    }
}
