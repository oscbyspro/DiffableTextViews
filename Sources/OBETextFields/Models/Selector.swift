//
//  Selector.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-25.
//

#warning("WIP")

struct Selector {
    typealias Base = Carets
    typealias Index = Base.Index
    typealias Indices = Base.Indices
    typealias Element = Base.Element
    
    // MARK: Properties
    
    let base: Base
    let indices: Indices
    
    // MARK: Uuilities
    
    /// - Complexity: O(1).
    @inlinable func next(_ index: Index) -> Index? {
        index < indices.last ? indices.index(after: index) : nil
    }
    
    /// - Complexity: O(1).
    @inlinable func prev(_ index: Index) -> Index? {
        index > indices.first ? indices.index(before: index) : nil
    }
    
    /// - Complexity: O(n) where n is the number of elements in base.
    @usableFromInline func move(_ index: inout Index, step: (Index) -> Index?, while predicate: (Element) -> Bool) {
        while predicate(base[index]), let next = step(index) { index = next }
    }
    
    /// - Complexity: O(n) where n is the number of elements in base.
    @usableFromInline func moveInsideBounds(_ index: inout Index) {
        move(&index, step: next, while: { $0.rhs.attribute == .prefix })
        move(&index, step: prev, while: { $0.lhs.attribute == .suffix })
    }
}
