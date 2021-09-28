//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

@usableFromInline struct Carets: BidirectionalCollection {
    @usableFromInline let snapshot: Snapshot
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
    }
    
    // MARK: Indices
    
    @inlinable var startIndex: Index {
        Index(lhs: nil, rhs: snapshot.startIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(lhs: snapshot.endIndex, rhs: nil)
    }
    
    @inlinable var firstIndex: Index {
        startIndex
    }
    
    @inlinable var lastIndex: Index {
        Index(lhs: subindex(before: snapshot.endIndex), rhs: snapshot.endIndex)
    }
    
    // MARK: Indices: Interoperabilities
        
    @inlinable func index(lhs subindex: Snapshot.Index) -> Index {
        Index(lhs: subindex, rhs: self.subindex(after: subindex))
    }
    
    @inlinable func index(rhs subindex: Snapshot.Index) -> Index {
        Index(lhs: self.subindex(before: subindex), rhs: subindex)
    }
    
    @inlinable func indices(lhs subindices: Range<Snapshot.Index>) -> Range<Index> {
        index(lhs: subindices.lowerBound) ..< index(lhs: subindices.upperBound)
    }
    
    @inlinable func indices(rhs subindices: Range<Snapshot.Index>) -> Range<Index> {
        index(rhs: subindices.lowerBound) ..< index(rhs: subindices.upperBound)
    }
    
    // MARK: Elements
    
    @inlinable var first: Element {
        first!
    }
    
    @inlinable var last: Element {
        last!
    }
    
    // MARK: Traversals
    
    @inlinable func index(after i: Index) -> Index {
        Index(lhs: i.rhs!, rhs: subindex(after: i.rhs!))
    }
    
    @inlinable func index(before i: Index) -> Index {
        Index(lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }
    
    // MARK: Subscripts
    
    @inlinable subscript(position: Index) -> Element {
        _read {
            yield Element(lhs: subelement(at: position.lhs), rhs: subelement(at: position.rhs))
        }
    }
    
    // MARK: Helpers: Subindex

    @inlinable func subindex(after subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex < snapshot.endIndex ? snapshot.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex > snapshot.startIndex ? snapshot.index(before: subindex) : nil
    }
    
    // MARK: Helpers: Subelement
    
    @inlinable func subelement(at subindex: Snapshot.Index?) -> Snapshot.Element? {
        guard let subindex = subindex, subindex < snapshot.endIndex else { return nil }
        
        return snapshot[subindex]
    }
    
    // MARK: Components
    
    @usableFromInline struct Element: Equatable {
        @usableFromInline let lhs: Snapshot.Element?
        @usableFromInline let rhs: Snapshot.Element?
        
        // MARK: Initializers
        
        @inlinable init(lhs: Snapshot.Element?, rhs: Snapshot.Element?) {
            self.lhs = lhs
            self.rhs = rhs
        }
    }
    
    @usableFromInline struct Index: Comparable {
        @usableFromInline let lhs: Snapshot.Index?
        @usableFromInline let rhs: Snapshot.Index?
        
        // MARK: Initializers
        
        @inlinable init(lhs: Snapshot.Index, rhs: Snapshot.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(lhs: Snapshot.Index, rhs: Snapshot.Index?) {
            self.lhs = lhs
            self.rhs = rhs
        }
        @inlinable init(lhs: Snapshot.Index?, rhs: Snapshot.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        // MARK: Getters
        
        @inlinable var offset: Int {
            rhs?.offset ?? (lhs!.offset + 1)
        }
        
        // MARK: Comparable
                
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.offset < rhs.offset
        }
    }
}

// MARK: - Others + Initializers

extension Snapshot {
    @inlinable var carets: Carets {
        Carets(self)
    }
}
