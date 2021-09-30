//
//  Insights.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-29.
//

@usableFromInline struct Insights<Base: Collection, Output>: Collection {
    @usableFromInline typealias Element = Output
    @usableFromInline typealias Index = Base.Index
    @usableFromInline typealias Indices = DefaultIndices<Self>
    @usableFromInline typealias SubSequence = Slice<Self>
    @usableFromInline typealias View = (Base.Element) -> Output
    
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

// MARK: - Collection + Initializers

extension Collection {
    @inlinable func view<Output>(_ view: @escaping (Element) -> Output) -> Insights<Self, Output> {
        Insights(self, view: view)
    }
}
