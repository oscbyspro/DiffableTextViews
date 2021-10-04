//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

@usableFromInline struct Field: BidirectionalCollection {
    @usableFromInline let layout: Layout
    
    // MARK: Initializers
    
    @inlinable init(_ layout: Layout) {
        self.layout = layout
    }
    
    // MARK: Components
    
    @usableFromInline struct Element {
        @usableFromInline static let symbolBeyondLowerBound: Symbol = .prefix("<")
        @usableFromInline static let symbolBeyondUpperBound: Symbol = .suffix(">")
        
        // MARK: Storage
        
        @usableFromInline let lhs: Symbol
        @usableFromInline let rhs: Symbol
        
        // MARK: Initialization

        @inlinable init(lhs: Symbol?, rhs: Symbol?) {
            self.lhs = lhs ?? Self.symbolBeyondLowerBound
            self.rhs = rhs ?? Self.symbolBeyondUpperBound
        }
    }
    
    @usableFromInline struct Index: Comparable {
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

    @inlinable func subindex(after subindex: Layout.Index) -> Layout.Index? {
        subindex < layout.endIndex ? layout.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Layout.Index) -> Layout.Index? {
        subindex > layout.startIndex ? layout.index(before: subindex) : nil
    }
        
    @inlinable func subelement(at subindex: Layout.Index?) -> Layout.Element? {
        guard let subindex = subindex, subindex < layout.endIndex else {
            return nil
        }

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
        
    @inlinable func index(lhs subindex: Layout.Index) -> Index {
        Index(lhs: subindex, rhs: self.subindex(after: subindex))
    }
    
    @inlinable func index(rhs subindex: Layout.Index) -> Index {
        Index(lhs: self.subindex(before: subindex), rhs: subindex)
    }
    
    @inlinable func indices(lhs subindices: Range<Layout.Index>) -> Range<Index> {
        index(lhs: subindices.lowerBound) ..< index(lhs: subindices.upperBound)
    }
    
    @inlinable func indices(rhs subindices: Range<Layout.Index>) -> Range<Index> {
        index(rhs: subindices.lowerBound) ..< index(rhs: subindices.upperBound)
    }
}

#warning("Rename 'position' to 'caret' or something similar.")
    
extension Field {
    // MARK: First Index Beyond
    
    @inlinable func firstIndex(after position: Index) -> Index? {
        firstIndex(after: position, where: { _ in true })
    }
    
    @inlinable func firstIndex(before position: Index) -> Index? {
        firstIndex(before: position, where: { _ in true })
    }
    
    @inlinable func firstIndex(after position: Index, where predicate: (Element) -> Bool) -> Index? {
        firstIndex(beyond: position, where: predicate, next: index(after:), end: lastIndex)
    }
    
    @inlinable func firstIndex(before position: Index, where predicate: (Element) -> Bool) -> Index? {
        firstIndex(beyond: position, where: predicate, next: index(before:), end: firstIndex)
    }
        
    @inlinable func firstIndex(beyond position: Index, where predicate: (Element) -> Bool, next: (Index) -> Index, end: Index) -> Index? {
        var current = position
        
        func peak() -> Index? {
            current != end ? next(current) : nil
        }
        
        guard let index = peak() else { return nil }
        current = index
        
        while let index = peak() {
            current = index
            
            if predicate(self[current]) { return current }
        }
        
        return nil
    }
}
