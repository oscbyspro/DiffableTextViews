//
//  Insights.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-29.
//

@usableFromInline struct Insights<Base: Collection, Element>: Collection {
    @usableFromInline typealias View = (Base.Element) -> Element
    @usableFromInline typealias Index = Base.Index
    
    // MARK: Storage
    
    @usableFromInline let base: Base
    @usableFromInline let view: View
    
    // MARK: Initializers
    
    @inlinable init(_ base: Base, view: @escaping View) {
        self.base = base
        self.view = view
    }
    
    // MARK: Indices
    
    @inlinable var startIndex: Index {
        base.startIndex
    }
    
    @inlinable var endIndex: Index {
        base.endIndex
    }
    
    // MARK: Traversal
    
    @inlinable func index(after i: Index) -> Index {
        base.index(after: i)
    }
    
    @inlinable func index(before i: Index) -> Index where Base: BidirectionalCollection {
        base.index(before: i)
    }
    
    // MARK: Subscripts
    
    @inlinable subscript(position: Index) -> Element {
        _read {
            yield view(base[position])
        }
    }
}

// MARK: - BidirectionalCollection

extension Insights: BidirectionalCollection where Base: BidirectionalCollection { }

// MARK: - RandomAccessCollection

extension Insights: RandomAccessCollection where Base: RandomAccessCollection { }

// MARK: - Others + Initializers

extension Collection {
    @inlinable func insights<Value>(_ view: @escaping (Element) -> Value) -> Insights<Self, Value> {
        Insights(self, view: view)
    }
}
