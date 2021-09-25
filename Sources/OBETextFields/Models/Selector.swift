//
//  Selector.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-25.
//

struct Selector {
    typealias Index = Carets.Index
    typealias Indices = Carets.Indices
    
    // MARK: Properties
    
    let carets: Carets
    let indices: Indices
    
    // MARK: Initializers
    
    @inlinable init(field: Field) {
        self.carets = field.carets
        self.indices = carets.indices
    }
    
    // MARK: Utilities
    
    /// - Complexity: O(1).
    @inlinable func next(_ index: Index) -> Index? {
        index < indices.last ? indices.index(after: index) : nil
    }
    
    /// - Complexity: O(1).
    @inlinable func prev(_ index: Index) -> Index? {
        index > indices.first ? indices.index(before: index) : nil
    }
    
    /// - Complexity: O(n) where n is the number of elements in base.
    @usableFromInline func move(_ index: inout Index, step: (Index) -> Index?, while predicate: (Caret) -> Bool) {
        while predicate(carets[index]), let next = step(index) { index = next }
    }
    
    /// - Complexity: O(n) where n is the number of elements in base.
    @usableFromInline func moveInsideBounds(_ index: inout Index) {
        move(&index, step: next, while: { $0.rhs.attribute == .prefix })
        move(&index, step: prev, while: { $0.lhs.attribute == .suffix })
    }
}
