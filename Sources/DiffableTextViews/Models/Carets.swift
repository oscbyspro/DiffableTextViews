//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

#warning("Rework.")
#warning("Rework.")
#warning("Rework.")

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
    
    /// - Complexity: O(n).
    @inlinable init(snapshot: Snapshot) {
        self.snapshot = snapshot
        self.range = .zero ..< .max(in: snapshot.characters)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - BidirectionalCollection
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Nonempty
    //=------------------------------------------------------------------------=
    
    @inlinable var isEmpty: Bool {
        false
    }
    
    @inlinable var firstIndex: Index {
        startIndex
    }
    
    @inlinable var lastIndex: Index {
        index(before: endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Range
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        Index(at: range.lowerBound, lhs: nil, rhs: snapshot.startIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(at: range.upperBound, lhs: snapshot.endIndex, rhs: nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traversal
    //=------------------------------------------------------------------------=
    
    #warning("Improve, maybe.")
    @inlinable func index(after i: Index) -> Index {
        Index(at: i.offset.after(character(at: i.rhs!.character)),  lhs: i.rhs!,  rhs: subindex(after: i.rhs!))
    }
    
    #warning("Improve, maybe.")
    @inlinable func index(before i: Index) -> Index {
        Index(at: i.offset.before(character(at: i.lhs!.character)), lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }
    
    // MARK: Traversal - Look
    
    @inlinable func look(start: Carets.Index, direction: Direction) -> Carets.Index {
        direction == .forwards
        ? self[start...].firstIndex(where: \.nonlookaheadable) ??  lastIndex
        : self[...start].lastIndex(where: \.nonlookbehindable) ?? startIndex
    }
    
    //
    // MARK: Traversal - Offset
    //=------------------------------------------------------------------------=
    
    @inlinable func index(at offset: Offset, start: Index) -> Index {
        start.offset <= offset
        ? indices[start...].first(where: { $0.offset == offset })!
        : indices[...start].last (where: { $0.offset == offset })!
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Access
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Peek {
        .init(lhs: subelement(at: position.lhs), rhs: subelement(at: position.rhs))
    }
    
    //
    // MARK: Access - Components
    //=------------------------------------------------------------------------=

    @inlinable func subindex(after subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex < snapshot.endIndex ? snapshot.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex > snapshot.startIndex ? snapshot.index(before: subindex) : nil
    }
        
    @inlinable func subelement(at subindex: Snapshot.Index?) -> Snapshot.Element? {
        guard let subindex = subindex else { return nil }
        return subindex < snapshot.endIndex ? snapshot[subindex] : nil
    }
    
    //
    // MARK: Access - Components - Character
    //=------------------------------------------------------------------------=

    #warning("Move, make subscript, maybe.")
    @inlinable func character(at index: String.Index) -> Character? {
        index < snapshot.characters.endIndex ? snapshot.characters[index] : nil
    }

    #warning("WIP.")
    @inlinable subscript(character index: String.Index) -> Character? {
        index < snapshot.characters.endIndex ? snapshot.characters[index] : nil
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
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            guard let l = lhs.rhs else { return false }
            guard let r = rhs.rhs else { return  true }
            return l < r
        }
    }
}
