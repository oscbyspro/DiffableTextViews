//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
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
    
    @usableFromInline init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
        self.range = Offset() ..< .size(of: snapshot.characters) // UTF16 is O(1)
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
// MARK: Carets - Collections Esque
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
    
    //=------------------------------------------------------------------------=
    // MARK: Translate
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after position: Index) -> Index {
        let index = snapshot.index(after: position.snapshot)
        let character = snapshot.characters[position.snapshot.character]
        return Index(index, at: position.offset + .size(of: character))
    }
    
    @inlinable func index(before position: Index) -> Index {
        let index = snapshot.index(before: position.snapshot)
        let character = snapshot.characters[index.character]
        return Index(index, at: position.offset - .size(of: character))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Inspect
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Movable
    //=------------------------------------------------------------------------=
    
    @inlinable func movable(start: Index, direction: Direction) -> Bool {
        switch direction {
        case .forwards:  return movable(forwards:  start)
        case .backwards: return movable(backwards: start)
        }
    }
    
    @inlinable func movable(forwards start: Index) -> Bool {
        snapshot.attributes[start.snapshot.attribute].contains(.prefixing)
    }
    
    @inlinable func movable(backwards start: Index) -> Bool {
        snapshot.attributes[start.snapshot.attribute].contains(.suffixing)
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
        case  .forwards: return index(forwards:  start)
        case .backwards: return index(backwards: start)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    #warning("FIXME.")
    @inlinable func index(forwards start: Index) -> Index {
        var position = start
        
        while position.snapshot != snapshot.endIndex {
            guard movable(forwards: position) else { return position }
            formIndex(after: &position)
        }
        
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    #warning("FIXME.")
    @inlinable func index(backwards start: Index) -> Index {
        var position = start
        
        while position.snapshot != snapshot.startIndex {
            formIndex(before: &position)
            guard movable(backwards: position) else { return position }
        }
        
        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Move To Destination
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func index(forwards start: Index, destination: Offset) -> Index {
        indices.first(where: { $0.offset >= destination }) ?? endIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable func index(backwards start: Index, destination: Offset) -> Index {
        indices.reversed().first(where: { $0.offset <= destination }) ?? startIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Index
    //=------------------------------------------------------------------------=
        
    @inlinable func index(start: Index, destination: Offset) -> Index {
        switch start.offset <= destination {
        case true:  return index(forwards:  start, destination: destination)
        case false: return index(backwards: start, destination: destination)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(start: Range<Index>, destination: Range<Offset>) -> Range<Index> {
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        var lowerBound = upperBound
        
        if !range.isEmpty {
            lowerBound = index(start: start.upperBound, destination: destination.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }

        print("indices:", range.upperBound, "-->", upperBound.offset)
        
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
