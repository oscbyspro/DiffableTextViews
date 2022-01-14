//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

#warning("WIP")
#warning("WIP")
#warning("WIP")

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
    
    @usableFromInline init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
        self.range = Offset() ..< .size(of: snapshot.characters) // UTF16 is O(1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable func preferred(_ position: Index, by preference: Direction) -> Bool {
        switch preference {
        case .forwards:  if position !=   endIndex { return self[position].nonprefixing }
        case .backwards: if position != startIndex { return self[index(before: position)].nonsuffixing }
        }
        
        return false
    }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*
    
    @usableFromInline struct Index: Comparable {
        
        //=------------------------------------------------------------------------=
        // MARK: Properties
        //=------------------------------------------------------------------------=
        
        @usableFromInline let snapshot: Snapshot.Index
        @usableFromInline let offset: Offset

        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(_ snapshot: Snapshot.Index, at offset: Offset) {
            self.snapshot = snapshot
            self.offset = offset
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Comparisons
        //=------------------------------------------------------------------------=
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.offset == rhs.offset
        }
        
        @inlinable static func <  (lhs: Self, rhs: Self) -> Bool {
            lhs.offset <  rhs.offset
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Collection
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Symbol {
        snapshot[position.snapshot]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Positions
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        Index(snapshot.startIndex, at: range.lowerBound)
    }
    
    @inlinable var endIndex: Index {
        Index(snapshot  .endIndex, at: range.upperBound)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Move
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after position: Index) -> Index {
        let index = snapshot.index(after: position.snapshot)
        let character = snapshot.characters[position.snapshot.character]
        return Index(index, at: position.offset + .size(of: character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable func index(before position: Index) -> Index {
        let index = snapshot.index(before: position.snapshot)
        let character = snapshot.characters[index.character]
        return Index(index, at: position.offset - .size(of: character))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Move In Direction
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic
    //=------------------------------------------------------------------------=
    
    @inlinable func index(start: Index, direction: Direction) -> Index {
        switch direction {
        case  .forwards: return firstIndex(where: \.nonprefixing) ??   endIndex
        case .backwards: return  lastIndex(where: \.nonsuffixing) ?? startIndex
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Move To Destination
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic - One
    //=------------------------------------------------------------------------=
        
    @inlinable func index(start: Index, destination: Offset) -> Index {
        switch start.offset <= destination {
        case true:  return indices[start...].first(where: { $0.offset >= destination }) ??   endIndex
        case false: return indices[...start] .last(where: { $0.offset <= destination }) ?? startIndex
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic - Two
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(start: Range<Index>, destination: Range<Offset>) -> Range<Index> {
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        var lowerBound = upperBound
        
        if !range.isEmpty {
            lowerBound = index(start: start.upperBound, destination: destination.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        
        return lowerBound ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Utilities
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func direction(at position: Index) -> Direction? {
        let peek = peek(at: position)

        let forwards  = peek.lhs.contains(.prefixing) && peek.rhs.contains(.prefixing)
        let backwards = peek.lhs.contains(.suffixing) && peek.rhs.contains(.suffixing)
        
        if forwards == backwards { return nil }
        return forwards ? .forwards : .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(at position: Index) -> (lhs: Attribute, rhs: Attribute) {(
        //=--------------------------------------=
        // MARK: LHS
        //=--------------------------------------=
        position.snapshot != snapshot.startIndex
        ? snapshot[snapshot.index(before: position.snapshot)].attribute : .prefixing,
        //=--------------------------------------=
        // MARK: RHS
        //=--------------------------------------=
        position.snapshot != snapshot.endIndex
        ? snapshot[position.snapshot].attribute : .suffixing
    )}
}
