//
//  Carets.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

//*============================================================================*
// MARK: * Carets
//*============================================================================*

/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |>|o|o|o|x|o|o|o|o|o|o|o|<|<|<|<|~
/// ```
///
/// - Methods prefixed as move treat indices as is, whereas methods prefixed as look treat indices from the caret's point of view.
/// As such, they behave the same way forwards and differently backwards — since a carets position is in front of its index.
///
///
@usableFromInline struct Carets<Scheme: DiffableTextViews.Scheme>: BidirectionalCollection {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline let snapshot: Snapshot

    //=------------------------------------------------------------------------=
    // MARK: Properties - Indices
    //=------------------------------------------------------------------------=

    @usableFromInline let startIndex: Index
    @usableFromInline let   endIndex: Index

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @usableFromInline init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
        self.startIndex = Index(snapshot.startIndex, at: .zero)
        self  .endIndex = Index(snapshot  .endIndex, at: .size(of: snapshot.characters))
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var characters: Snapshot.Characters {
        snapshot.characters
    }

    @inlinable var attributes: Snapshot.Attributes {
        snapshot.attributes
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=

    @inlinable subscript(position: Index) -> Symbol {
        snapshot[position.snapshot]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traversal
    //=------------------------------------------------------------------------=

    @inlinable func index(after position: Index) -> Index {
        let character = characters[position.character]
        let after = snapshot.index(after: position.snapshot)
        return Index(after, at: position.offset.after(character))
    }
    
    @inlinable func index(before position: Index) -> Index {
        let before = snapshot.index(before: position.snapshot)
        let character = characters[before.character]
        return Index(before, at: position.offset.before(character))
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
        // MARK: Accessors
        //=------------------------------------------------------------------------=

        @inlinable var character: Snapshot.Characters.Index {
            snapshot.character
        }

        @inlinable var attribute: Snapshot.Attributes.Index {
            snapshot.attribute
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
// MARK: Carets - Move
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic
    //=------------------------------------------------------------------------=
    
    @inlinable func move(start: Index, direction: Direction, while predicate: (Index) -> Bool) -> Index {
        switch direction {
        case  .forwards: return move( forwards: start, while: predicate)
        case .backwards: return move(backwards: start, while: predicate)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=

    @inlinable func move(forwards position: Index, while predicate: (Index) -> Bool) -> Index {
        var position = position

        while position != endIndex {
            guard predicate(position) else { return position }
            formIndex(after: &position)
        }

        return position
    }

    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=

    @inlinable func move(backwards position: Index, while predicate: (Index) -> Bool) -> Index {
        var position = position
        
        while position != startIndex {
            guard predicate(position) else { return position }
            formIndex(before: &position)
        }

        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Look - While
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic
    //=------------------------------------------------------------------------=
    
    @inlinable func look(start: Index, direction: Direction, while predicate: (Index) -> Bool) -> Index {
        switch direction {
        case  .forwards: return look( forwards: start, while: predicate)
        case .backwards: return look(backwards: start, while: predicate)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func look(forwards position: Index, while predicate: (Index) -> Bool) -> Index {
        move(forwards: position, while: predicate)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable func look(backwards position: Index, while predicate: (Index) -> Bool) -> Index {
        var position = position
        
        while position != startIndex {
            let after = position
            formIndex(before: &position)
            guard predicate(position) else { return after }
        }

        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Breakpoint
//=----------------------------------------------------------------------------=

extension Carets {

    //=------------------------------------------------------------------------=
    // MARK: Inspect
    //=------------------------------------------------------------------------=

    @inlinable func breaks(at position: Index, direction: Direction) -> Bool {
        switch direction {
        case  .forwards: return !peek(position).rhs.contains(.prefixing)
        case .backwards: return !peek(position).lhs.contains(.suffixing)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Dynamic
    //=------------------------------------------------------------------------=

    @inlinable func breakpoint(start: Index, direction: Direction) -> Index {
        switch direction {
        case  .forwards: return breakpoint( forwards: start)
        case .backwards: return breakpoint(backwards: start)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=

    @inlinable func breakpoint(forwards start: Index) -> Index {
        look(forwards: start) { position in
            attributes[position.attribute].contains(.prefixing)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable func breakpoint(backwards start: Index) -> Index {
        look(backwards: start) { position in
            attributes[position.attribute].contains(.suffixing)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Move To Destination
//=----------------------------------------------------------------------------=

extension Carets {

    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=

    @inlinable func indices(start: Range<Index>, destination: Range<Offset>) -> Range<Index> {
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        var lowerBound = upperBound

        if !destination.isEmpty {
            lowerBound = index(start: start.lowerBound, destination: destination.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        
        return lowerBound ..< upperBound
    }

    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=

    @inlinable func index(start: Index, destination: Offset) -> Index {
        switch start.offset <= destination {
        case  true: return index( forwards: start, destination: destination)
        case false: return index(backwards: start, destination: destination)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=

    @inlinable func index(forwards start: Index, destination: Offset) -> Index {
        move(forwards: start) { position in
            position.offset < destination
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=

    @inlinable func index(backwards start: Index, destination: Offset) -> Index {
        move(backwards: start) { position in
            position.offset > destination
        }
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
        let peek = peek(position)

        let forwards  = peek.lhs.contains(.prefixing) && peek.rhs.contains(.prefixing)
        let backwards = peek.lhs.contains(.suffixing) && peek.rhs.contains(.suffixing)

        if forwards == backwards { return nil }
        return forwards ? .forwards : .backwards
    }

    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=

    @inlinable func peek(_ position: Index) -> (lhs: Attribute, rhs: Attribute) {(
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
