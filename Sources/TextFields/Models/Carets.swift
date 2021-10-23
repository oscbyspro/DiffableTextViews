//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

// MARK: - Carets

#warning("Count optimizations were removed, rememver to check whether they are still called.")
@usableFromInline struct Carets: BidirectionalCollection {
    @usableFromInline typealias Layout = TextFields.Layout<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let layout: Layout
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot) {
        self.layout = Layout(snapshot)
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
        
        @usableFromInline let lhs: Layout.Index?
        @usableFromInline let rhs: Layout.Index?
        
        // MARK: Initialization
        
        @inlinable init(lhs: Layout.Index, rhs: Layout.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(lhs: Layout.Index, rhs: Layout.Index?) {
            self.lhs = lhs
            self.rhs = rhs
        }
        @inlinable init(lhs: Layout.Index?, rhs: Layout.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
                
        // MARK: Comparable
                
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            guard let a = lhs.rhs else { return false }
            guard let b = rhs.rhs else { return  true }
            
            return a < b
        }
    }
}

// MARK: - BidirectionalCollection

extension Carets {
    
    // MARK: Bounds
    
    @inlinable var startIndex: Index {
        Index(lhs: nil, rhs: layout.startIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(lhs: layout.endIndex, rhs: nil)
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

    @inlinable func subindex(after subindex: Layout.Index) -> Layout.Index? {
        subindex < layout.endIndex ? layout.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Layout.Index) -> Layout.Index? {
        subindex > layout.startIndex ? layout.index(before: subindex) : nil
    }
    
    // MARK: Helpers: Subelement
    
    @inlinable func subelement(at subindex: Layout.Index?) -> Snapshot.Element? {
        guard let subindex = subindex, subindex < layout.endIndex else { return nil }
        
        return layout[subindex]
    }
}

// MARK: - Nonempty

extension Carets {
    
    // MARK: Element
    
    @inlinable var first: Element {
        first!
    }
    
    @inlinable var last: Element {
        last!
    }
    
    // MARK: Index
    
    @inlinable var firstIndex: Index {
        startIndex
    }
    
    @inlinable var lastIndex: Index {
        index(before: endIndex)
    }
}

// MARK: - Interoperabilities

extension Carets {
    
    // MARK: Index
        
    @inlinable func index(lhs i: Layout.Index) -> Index {
        Index(lhs: i, rhs: subindex(after: i))
    }

    @inlinable func index(rhs i: Layout.Index) -> Index {
        Index(lhs: subindex(before: i), rhs: i)
    }
    
    // MARK: Indices
    
    @inlinable func indices(lhs subindices: Range<Layout.Index>) -> Range<Index> {
        index(lhs: subindices.lowerBound) ..< index(lhs: subindices.upperBound)
    }
    
    @inlinable func indices(rhs subindices: Range<Layout.Index>) -> Range<Index> {
        index(rhs: subindices.lowerBound) ..< index(rhs: subindices.upperBound)
    }
}
