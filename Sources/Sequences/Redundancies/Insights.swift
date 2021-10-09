//
//  Insights.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-29.
//

// MARK: - Insights

/// Depricated. Saved for inspiration.
///
/// Essentially Collection.lazy.map(_:).
public struct Insights<Base: Collection, Output>: Collection {
    public typealias Element = Output
    public typealias Index = Base.Index
    public typealias Indices = DefaultIndices<Self>
    public typealias SubSequence = Slice<Self>
    public typealias View = (Base.Element) -> Output
    
    // MARK: Storage
    
    @usableFromInline let base: Base
    @usableFromInline let view: View
    
    // MARK: Initializers
    
    @inlinable public init(_ base: Base, view: @escaping View) {
        self.base = base
        self.view = view
    }
    
    // MARK: Indices
    
    @inlinable public var startIndex: Index {
        base.startIndex
    }
    
    @inlinable public var endIndex: Index {
        base.endIndex
    }
    
    // MARK: Traversal
    
    @inlinable public func index(after i: Index) -> Index {
        base.index(after: i)
    }
    
    @inlinable public func index(before i: Index) -> Index where Base: BidirectionalCollection {
        base.index(before: i)
    }
    
    // MARK: Subscripts
    
    @inlinable public subscript(position: Index) -> Element {
        _read {
            yield view(base[position])
        }
    }
}

// MARK: Conformances

extension Insights: BidirectionalCollection where Base: BidirectionalCollection { }
extension Insights: RandomAccessCollection where Base: RandomAccessCollection { }

// MARK: - Collection

public extension Collection {
    // MARK: Make

    @inlinable func view<Output>(_ view: @escaping (Element) -> Output) -> Insights<Self, Output> {
        Insights(self, view: view)
    }
}

// MARK: - CompactInsights

public struct CompactInsights<Base: Collection, Output>: Collection {
    public typealias Element = Output
    public typealias Index = Base.Index
    public typealias Indices = DefaultIndices<Self>
    public typealias SubSequence = Slice<Self>
    public typealias View = (Base.Element) -> Output?
    
    // MARK: Storage
    
    @usableFromInline let base: Base
    @usableFromInline let view: View
    
    // MARK: Initializers
    
    @inlinable public init(_ base: Base, view: @escaping View) {
        self.base = base
        self.view = view
    }
    
    // MARK: Indices
    
    @inlinable public var startIndex: Index {
        base.startIndex
    }
    
    @inlinable public var endIndex: Index {
        base.endIndex
    }
    
    // MARK: Traversal
    
    @inlinable public func index(after i: Index) -> Index {
        var index = base.index(after: i)
        
        while index < base.endIndex, view(base[index]) == nil {
            index = base.index(after: index)
        }
        
        return index
    }
    
    @inlinable public func index(before i: Index) -> Index where Base: BidirectionalCollection {
        var index = base.index(before: i)
        
        while index > base.startIndex, view(base[index]) == nil {
            index = base.index(after: index)
        }
        
        return index
    }
    
    // MARK: Subscripts

    @inlinable public subscript(position: Index) -> Element {
        _read {
            yield view(base[position])!
        }
    }
}

// MARK: Conformances

extension CompactInsights: BidirectionalCollection where Base: BidirectionalCollection { }
extension CompactInsights: RandomAccessCollection where Base: RandomAccessCollection { }

public extension Collection {
    // MARK: Make
    
    @inlinable func compactView<Output>(_ view: @escaping (Element) -> Output?) -> CompactInsights<Self, Output> {
        CompactInsights(self, view: view)
    }
}
