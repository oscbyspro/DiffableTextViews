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
    
    #warning("Use: Range or ClosedRange?")
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
        return Index(index, at: position.offset + .size(of: character))
    }
}

#warning("WIP")
#warning("WIP")
#warning("WIP")
extension Carets {
  
    //=------------------------------------------------------------------------=
    // MARK: Move - Multiple
    //=------------------------------------------------------------------------=
    
    @inlinable func move(position: Index, direction: Direction) -> Index {
        switch direction {
        case  .forwards: return  forwards(start: position)
        case .backwards: return backwards(start: position)
        }
    }
        
    @inlinable func forwards(start: Index) -> Index {
        var position = start
        
        while position.snapshot != snapshot.endIndex {
            if !snapshot.attributes[position.snapshot.attribute].contains(.prefixing) { return position }
            formIndex(after: &position)
        }
        
        return position
    }
    
    @inlinable func backwards(start: Index) -> Index {
        var position = start
        
        while position.snapshot != snapshot.startIndex {
            let after = position
            formIndex(before: &position)
            guard snapshot.attributes[position.snapshot.attribute].contains(.suffixing) else { return after }
        }
        
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Move - Multiple - Destination
    //=------------------------------------------------------------------------=
        
    @inlinable func forwards(start: Index, destination: Offset) -> Index {
        var position = start
        
        while position.snapshot != snapshot.endIndex {
            guard position.offset < destination else { return position }
            formIndex(after: &position)
        }
        
        return position
    }
    
    @inlinable func backwards(start: Index, destination: Offset) -> Index {
        var position = start
        
        while position.snapshot != snapshot.startIndex {
            let after = position
            formIndex(before: &position)
            guard position.offset > destination else { return after }
        }
        
        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Indices
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Offset
    //=------------------------------------------------------------------------=

    @inlinable func indices(at range: Range<Offset>, start: Range<Index>) -> Range<Index> {
        let upperBound = index(at: range.upperBound, start: start.upperBound)
        var lowerBound = upperBound
        
        if !range.isEmpty {
            lowerBound = index(at: range.lowerBound, start: start.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }

        return lowerBound ..< upperBound
    }
    
    @inlinable func index(at destination: Offset, start: Index) -> Index {
        if start.offset <= destination { return  forwards(start: start, destination: destination) }
        else                           { return backwards(start: start, destination: destination) }
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
        position.snapshot != snapshot.startIndex ? snapshot[snapshot.index(before: position.snapshot)].attribute : .prefixing,
        position.snapshot !=   snapshot.endIndex ? snapshot[position.snapshot].attribute : .suffixing
    )}
}
