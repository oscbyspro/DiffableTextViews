//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

// MARK: - Field

#warning("Rename as Carets.")
#warning("Count optimizations were removed, rememver to check whether they are still called.")
@usableFromInline struct Carets: BidirectionalCollection {
    @usableFromInline typealias Layout = TextFields.Layout<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let layout: Layout
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot) {
        self.layout = Layout(snapshot)
    }
    
    // MARK: Utilities
    
    #warning("FIXME")
    @inlinable func offset16(from start: Index, to end: Index) -> Int {
        fatalError()
        
//        let lowerBound = start.rhs?.character ?? layout.characters.endIndex
//        let upperBound =   end.rhs?.character ?? layout.characters.endIndex
//
//        return layout.characters.utf16[lowerBound ..< upperBound].count
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

extension Carets {
    
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

    @inlinable func subindex(after subindex: Layout.Index) -> Layout.Index? {
        subindex < layout.endIndex ? layout.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Layout.Index) -> Layout.Index? {
        subindex > layout.startIndex ? layout.index(before: subindex) : nil
    }
    
    // MARK: Helpers
    
    @inlinable func subelement(at subindex: Layout.Index?) -> Snapshot.Element? {
        guard let subindex = subindex, subindex < layout.endIndex else { return nil }
        
        return layout[subindex]
    }
}

extension Carets {
    
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

extension Carets {
    
    // MARK: Interoperabilities
        
//    @inlinable func index(lhs subindex: Layout.Index) -> Index {
//        Index(lhs: subindex, rhs: self.subindex(after: subindex))
//    }
//    
//    @inlinable func index(rhs subindex: Layout.Index) -> Index {
//        Index(lhs: self.subindex(before: subindex), rhs: subindex)
//    }
//    
//    @inlinable func indices(lhs subindices: Range<Layout.Index>) -> Range<Index> {
//        index(lhs: subindices.lowerBound) ..< index(lhs: subindices.upperBound)
//    }
//    
//    @inlinable func indices(rhs subindices: Range<Layout.Index>) -> Range<Index> {
//        index(rhs: subindices.lowerBound) ..< index(rhs: subindices.upperBound)
//    }
}
