//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#warning("Make Caret generic like Caret<Index>")

@usableFromInline struct Caret: Comparable {
    @usableFromInline let lhs: Symbols.Index?
    @usableFromInline let rhs: Symbols.Index?
        
    // MARK: Initializers
    
    @inlinable init(lhs: Symbols.Index, rhs: Symbols.Index?) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
    @inlinable init(lhs: Symbols.Index?, rhs: Symbols.Index) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
    // MARK: Utilities
    
    @inlinable var offset: Int {
        lhs.map({ $0.offset + 1 }) ?? 0
    }
    
    @inlinable var min: Symbols.Index {
        lhs ?? rhs!
    }
    
    @inlinable var max: Symbols.Index {
        rhs ?? lhs!
    }
    
    // MARK: Comparable
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.offset < rhs.offset
    }
}
