//
//  Carets.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

@usableFromInline struct Carets<Base: Collection>: Collection {
    @usableFromInline typealias Indices = DefaultIndices<Self>
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

    // MARK: Traversals
    
    @inlinable func index(after i: Index) -> Index {
        Index(lhs: i.rhs!, rhs: subindex(after: i.rhs!))
    }
    
    @inlinable func index(before i: Index) -> Index where Base: BidirectionalCollection {
        Index(lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }
    
    // MARK: Subscripts
    
    @inlinable subscript(position: Index) -> Element {
        _read {
            yield Element(lhs: subelement(at: position.lhs), rhs: subelement(at: position.rhs))
        }
    }
    
    // MARK: Helpers: Indices
        
    @inlinable func index(lhs subindex: Base.Index) -> Index {
        Index(lhs: subindex, rhs: self.subindex(after: subindex))
    }
    
    @inlinable func index(rhs subindex: Base.Index) -> Index where Base: BidirectionalCollection {
        Index(lhs: self.subindex(before: subindex), rhs: subindex)
    }
    
    @inlinable func indices(lhs subindices: Range<Base.Index>) -> Range<Index> {
        index(lhs: subindices.lowerBound) ..< index(lhs: subindices.upperBound)
    }
    
    @inlinable func indices(rhs subindices: Range<Base.Index>) -> Range<Index> where Base: BidirectionalCollection {
        index(rhs: subindices.lowerBound) ..< index(rhs: subindices.upperBound)
    }
    
    // MARK: Helpers: Subindex

    @inlinable func subindex(after subindex: Base.Index) -> Base.Index? {
        subindex < base.endIndex ? base.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Base.Index) -> Base.Index? where Base: BidirectionalCollection {
        subindex > base.startIndex ? base.index(before: subindex) : nil
    }
    
    // MARK: Helpers: Subelement
    
    @inlinable func subelement(at subindex: Base.Index?) -> Base.Element? {
        guard let subindex = subindex, subindex < base.endIndex else {
            return nil
        }
        
        return base[subindex]
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
        
        @inlinable init(lhs: Base.Index, rhs: Base.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(lhs: Base.Index, rhs: Base.Index?) {
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

// MARK: - NonEmptyCollection

extension Carets {
    @inlinable var first: Element {
        self[firstIndex]
    }
    
    @inlinable var firstIndex: Index {
        startIndex
    }
}

extension Carets where Base: BidirectionalCollection {
    @inlinable var last: Element {
        self[lastIndex]
    }
    
    @inlinable var lastIndex: Index {
        index(before: endIndex)
    }
}

// MARK: - BidirectionalCollection

extension Carets: BidirectionalCollection where Base: BidirectionalCollection { }

// MARK: - RandomAccessCollection

extension Carets: RandomAccessCollection where Base: RandomAccessCollection { }

// MARK: - Collection + Initializers

extension Collection {
    @inlinable var carets: Carets<Self> {
        Carets(base: self)
    }
}
