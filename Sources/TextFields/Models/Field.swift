//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

// MARK: - Field

@usableFromInline struct Field: BidirectionalCollection {
    
    // MARK: Properties
    
    @usableFromInline let layout: Snapshot
    
    // MARK: Initializers
    
    @inlinable init(_ layout: Snapshot) {
        self.layout = layout
    }
    
    // MARK: Components
    
    @usableFromInline struct Element {
        
        // MARK: Properties
        
        @usableFromInline let lhs: Symbol
        @usableFromInline let rhs: Symbol
        
        // MARK: Initialization

        @inlinable init(lhs: Symbol?, rhs: Symbol?) {
            self.lhs = lhs ?? .prefix("\0")
            self.rhs = rhs ?? .suffix("\0")
        }
    }
    
    @usableFromInline struct Index: Comparable {
        
        // MARK: Properties
        
        @usableFromInline let lhs: Snapshot.Index?
        @usableFromInline let rhs: Snapshot.Index?
        
        // MARK: Initialization
        
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
        
        // MARK: Utilities
        
        @inlinable var offset: Int {
            rhs?.offset ?? (lhs!.offset + 1)
        }
        
        // MARK: Comparable
                
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.offset < rhs.offset
        }
    }
}

extension Field {
    
    // MARK: Protocol: BidirectionalCollection
    
    @inlinable var startIndex: Index {
        Index(lhs: nil, rhs: layout.startIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(lhs: layout.endIndex, rhs: nil)
    }
    
    @inlinable func index(after i: Index) -> Index {
        Index(lhs: i.rhs!, rhs: subindex(after: i.rhs!))
    }
    
    @inlinable func index(before i: Index) -> Index {
        Index(lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }
    
    @inlinable subscript(position: Index) -> Element {
        _read {
            yield Element(lhs: subelement(at: position.lhs), rhs: subelement(at: position.rhs))
        }
    }
    
    // MARK: Helpers

    @inlinable func subindex(after subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex < layout.endIndex ? layout.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex > layout.startIndex ? layout.index(before: subindex) : nil
    }
    
    // MARK: Helpers
    
    @inlinable func subelement(at subindex: Snapshot.Index?) -> Snapshot.Element? {
        guard let subindex = subindex, subindex < layout.endIndex else { return nil }
        
        return layout[subindex]
    }
    
    // MARK: Optimization
    
    @inlinable var count: Int {
        layout.count + 1
    }
    
    @inlinable var underestimatedCount: Int {
        layout.underestimatedCount + 1
    }
}

extension Field {
    
    // MARK: Never Empty
    
    @inlinable var first: Element {
        first!
    }
    
    @inlinable var last: Element {
        last!
    }
    
    @inlinable var firstIndex: Index {
        startIndex
    }
    
    @inlinable var lastIndex: Index {
        index(before: endIndex)
    }
}

extension Field {
    
    // MARK: Interoperabilities
        
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
}
