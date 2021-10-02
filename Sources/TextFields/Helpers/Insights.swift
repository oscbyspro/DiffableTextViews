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

extension Insights: BidirectionalCollection where Base: BidirectionalCollection {
    // MARK: BidirectionalCollection
}


extension Insights: RandomAccessCollection where Base: RandomAccessCollection {
    // MARK: RandomAccessCollection
}

extension Collection {
    // MARK: Collection + Initializers
    
    @inlinable func view<Output>(_ view: @escaping (Element) -> Output) -> Insights<Self, Output> {
        Insights(self, view: view)
    }
}

// MARK: -

@usableFromInline struct CompactInsights<Base: Collection, Output>: Collection {
    @usableFromInline typealias Element = Output
    @usableFromInline typealias Index = Base.Index
    @usableFromInline typealias Indices = DefaultIndices<Self>
    @usableFromInline typealias SubSequence = Slice<Self>
    @usableFromInline typealias View = (Base.Element) -> Output?
    
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
        var index = base.index(after: i)
        
        while index < base.endIndex, view(base[index]) == nil {
            index = base.index(after: index)
        }
        
        return index
    }
    
    @inlinable func index(before i: Index) -> Index where Base: BidirectionalCollection {
        var index = base.index(before: i)
        
        while index > base.startIndex, view(base[index]) == nil {
            index = base.index(after: index)
        }
        
        return index
    }
    
    // MARK: Subscripts

    @inlinable subscript(position: Index) -> Element {
        _read {
            yield view(base[position])!
        }
    }
}

extension CompactInsights: BidirectionalCollection where Base: BidirectionalCollection {
    // MARK: BidirectionalCollection
}

extension Collection {
    // MARK: Collection + Initializers
    
    @inlinable func compactView<Output>(_ view: @escaping (Element) -> Output?) -> CompactInsights<Self, Output> {
        CompactInsights(self, view: view)
    }
}
