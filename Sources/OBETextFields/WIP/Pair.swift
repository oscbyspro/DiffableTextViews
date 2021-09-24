//
//  Pair.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#warning("!!!")

@usableFromInline struct Pair {
    @usableFromInline let lhs: Symbol?
    @usableFromInline let rhs: Symbol?
    
    @inlinable init(lhs: Symbol?, rhs: Symbol?) {
        self.lhs = lhs
        self.rhs = rhs
    }
}
