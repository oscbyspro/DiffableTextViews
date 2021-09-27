//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

@usableFromInline struct Carets<Base: Collection>: Collection {
    @usableFromInline typealias SubSequence = Slice<Self>
    
    // MARK: Storage
    
    @usableFromInline let base: Base
    
    // MARK: Initializers
    
    @inlinable init(base: Base) {
        self.base = base
    }
    
    // MARK: Indices
    
    @inlinable var startIndex: Index {
        Index(lhs: nil, rhs: base.startIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(lhs: base.endIndex, rhs: nil)
    }
    
    @inlinable func firstIndex() -> Index {
        startIndex
    }
    
    @inlinable func lastIndex() -> Index where Base: BidirectionalCollection {
        Index(lhs: base.index(before: base.endIndex), rhs: base.endIndex)
    }
    
    // MARK: Elements
    
    @inlinable func first() -> Element {
        first!
    }
    
    @inlinable func last() -> Element where Base: BidirectionalCollection {
        last!
    }
    
    // MARK: Traversal
    
    @inlinable func index(after i: Index) -> Index {
        Index(lhs: i.rhs!, rhs: baseIndex(after: i.rhs!))
    }
    
    @inlinable func index(before i: Index) -> Index where Base: BidirectionalCollection {
        Index(lhs: baseIndex(before: i.lhs!), rhs: i.lhs!)
    }
    
    // MARK: Collection: Subscripts
    
    @inlinable subscript(position: Index) -> Element {
        _read {
            yield Element(lhs: baseElement(at: position.lhs), rhs: baseElement(at: position.rhs))
        }
    }
    
    // MARK: Helpers: Base.Index

    @inlinable func baseIndex(after baseIndex: Base.Index) -> Base.Index? {
        baseIndex < base.endIndex ? base.index(after: baseIndex) : nil
    }

    @inlinable func baseIndex(before baseIndex: Base.Index) -> Base.Index? where Base: BidirectionalCollection {
        baseIndex > base.startIndex ? base.index(before: baseIndex) : nil
    }
    
    // MARK: Helpers: Base.Element
    
    @inlinable func baseElement(at baseIndex: Base.Index?) -> Base.Element? {
        guard let baseIndex = baseIndex, baseIndex < base.endIndex else {
            return nil
        }
        
        return base[baseIndex]
    }
    
    // MARK: Components
    
    @usableFromInline struct Element {
        @usableFromInline let lhs: Base.Element?
        @usableFromInline let rhs: Base.Element?
        
        // MARK: Initializers
        
        @inlinable init(lhs: Base.Element?, rhs: Base.Element?) {
            self.lhs = lhs
            self.rhs = rhs
        }
    }
    
    @usableFromInline struct Index: Comparable {
        @usableFromInline let lhs: Base.Index?
        @usableFromInline let rhs: Base.Index?
        
        // MARK: Initializers
        
        @inlinable init(lhs: Base.Index, rhs: Base.Index?) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(lhs: Base.Index, rhs: Base.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(lhs: Base.Index?, rhs: Base.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        // MARK: Comparable
                
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            guard let a = lhs.rhs else { return false }
            guard let b = rhs.rhs else { return true }
            
            return a < b
        }
    }
}

// MARK: - Equatable

extension Carets.Element: Equatable where Base.Element: Equatable { }

// MARK: - BidirectionalCollection

extension Carets: BidirectionalCollection where Base: BidirectionalCollection { }

// MARK: - RandomAccessCollection

extension Carets: RandomAccessCollection where Base: RandomAccessCollection { }

// MARK: - Collection + Carets

extension Collection {
    @inlinable var carets: Carets<Self> {
        Carets(base: self)
    }
}
