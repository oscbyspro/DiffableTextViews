//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

//*============================================================================*
// MARK: * Carets
//*============================================================================*

@usableFromInline struct Carets<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let snapshot: Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @usableFromInline init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
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
    
    @inlinable var start: Index {
        Index(snapshot.startIndex, at: .zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Move - Single
    //=------------------------------------------------------------------------=
    
    @inlinable func after(_ position: Index) -> Index {
        let index = snapshot.index(after: position.snapshot)
        let character = snapshot.characters[position.snapshot.character]
        return Index(index, at: position.offset + .size(of: character))
    }
    
    @inlinable func before(_ position: Index) -> Index {
        let index = snapshot.index(before: position.snapshot)
        let character = snapshot.characters[index.character]
        return Index(index, at: position.offset + .size(of: character))
    }
    
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
            position = after(position)
        }
        
        return position
    }
    
    @inlinable func backwards(start: Index) -> Index {
        var position = start
        
        while position.snapshot != snapshot.startIndex {
            let after = position
            position = before(position)
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
            position = after(position)
        }
        
        return position
    }
    
    @inlinable func backwards(start: Index, destination: Offset) -> Index {
        var position = start
        
        while position.snapshot != snapshot.startIndex {
            let after = position
            position = before(position)
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
            lowerBound = min(lowerBound, upperBound)
        }

        return lowerBound ..< upperBound
    }
    
    @inlinable func index(at destination: Offset, start: Index) -> Index {
        if start.offset <= destination { return  forwards(start: start, destination: destination) }
        else                           { return backwards(start: start, destination: destination) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    #error("Remove, maybe.")
//    @inlinable func indices(at range: Range<Snapshot.Index>) -> Range<Index> {
//        let lowerBound = Offset(at: range.lowerBound.character, in: snapshot.characters)
//        let difference = Offset(at: range.upperBound.character, in: snapshot.characters[range.lowerBound.character...])
//        return Index(range.lowerBound, at: lowerBound) ..< Index(range.upperBound, at: lowerBound + difference)
//    }
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
