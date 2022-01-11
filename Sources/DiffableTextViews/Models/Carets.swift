//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

//*============================================================================*
// MARK: * Carets
//*============================================================================*

@usableFromInline struct Carets<Scheme: DiffableTextViews.Scheme>: BidirectionalCollection {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let snapshot: Snapshot
    @usableFromInline let range: Range<Offset>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(snapshot: Snapshot) {
        self.snapshot = snapshot
        self.range = .zero ..< .max(in: snapshot.characters) // UTF16 is O(1)
    }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*
    
    @usableFromInline struct Index: Comparable {
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        @usableFromInline let offset: Offset
        @usableFromInline let lhs: Snapshot.Index?
        @usableFromInline let rhs: Snapshot.Index?
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        @inlinable init(at offset: Offset, lhs: Snapshot.Index, rhs: Snapshot.Index?) {
            self.offset = offset
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(at offset: Offset, lhs: Snapshot.Index?, rhs: Snapshot.Index) {
            self.offset = offset
            self.lhs = lhs
            self.rhs = rhs
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rhs == rhs.rhs
        }
        
        @inlinable static func <  (lhs: Self, rhs: Self) -> Bool {
            guard let l = lhs.rhs else { return false }
            guard let r = rhs.rhs else { return  true }
            return l < r
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - BidirectionalCollection
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Peek {
        Peek(lhs: subelement(at: position.lhs), rhs: subelement(at: position.rhs))
    }
    
    //
    // MARK: Accessors - Components
    //=------------------------------------------------------------------------=
        
    @inlinable func subelement(at position: Snapshot.Index?) -> Snapshot.Element? {
        guard let position = position else { return nil }
        return position < snapshot.endIndex ? snapshot[position] : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        Index(at: range.lowerBound, lhs: nil, rhs: snapshot.startIndex)
    }
    
    @inlinable var lastIndex: Index {
        index(before: endIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(at: range.upperBound, lhs: snapshot.endIndex, rhs: nil)
    }

    //=------------------------------------------------------------------------=
    // MARK: Traversal
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after position: Index) -> Index {
        Index(at: offset(after: position), lhs: position.rhs!, rhs: subindex(after: position.rhs!))
    }
    
    @inlinable func index(before position: Index) -> Index {
        Index(at: offset(before: position), lhs: subindex(before: position.lhs!), rhs: position.lhs!)
    }
    
    //
    // MARK: Traversal - Components
    //=------------------------------------------------------------------------=
    
    @inlinable func offset(after position: Index) -> Offset {
        position.offset.after(character(at: position.rhs!.character))
    }
    
    @inlinable func offset(before position: Index) -> Offset {
        position.offset.before(character(at: position.lhs!.character))
    }
    
    //
    // MARK: Traversal - Subcomponents
    //=------------------------------------------------------------------------=
    
    @inlinable func subindex(after position: Snapshot.Index) -> Snapshot.Index? {
        position < snapshot.endIndex ? snapshot.index(after: position) : nil
    }

    @inlinable func subindex(before position: Snapshot.Index) -> Snapshot.Index? {
        position > snapshot.startIndex ? snapshot.index(before: position) : nil
    }
    
    @inlinable func character(at position: String.Index) -> Character? {
        position < snapshot.characters.endIndex ? snapshot.characters[position] : nil
    }

    //=------------------------------------------------------------------------=
    // MARK: Traversal - Look In Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func look(start: Index, direction: Direction) -> Index {
        direction == .forwards
        ? self[start...].firstIndex(where: \.nonlookaheadable) ??  lastIndex
        : self[...start].lastIndex(where: \.nonlookbehindable) ?? startIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traversal - Index At Offset
    //=------------------------------------------------------------------------=
    
    @inlinable func index(at position: Offset, start: Index) -> Index {
        start.offset <= position
        ? indices[start...].first(where: { $0.offset >= position })!
        : indices[...start].last (where: { $0.offset <= position })!
    }
    
    @inlinable func indices(at range: Range<Offset>, start: Range<Index>) -> Range<Index> {
        let upperBound =                              index(at: range.upperBound, start: start.upperBound)
        let lowerBound = range.isEmpty ? upperBound : index(at: range.lowerBound, start: start.lowerBound)
        return lowerBound ..< upperBound
    }
}
