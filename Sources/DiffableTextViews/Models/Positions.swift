//
//  Positions.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

#warning("Rename.")

//*============================================================================*
// MARK: * Positions
//*============================================================================*

/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|x
/// ```
@usableFromInline struct Positions<Scheme: DiffableTextViews.Scheme>: BidirectionalCollection {
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>

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
        self.startIndex = Index(snapshot.startIndex, at: .start)
        self  .endIndex = Index(snapshot  .endIndex, at: .end(of: snapshot.characters))
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
    // MARK: Elements
    //=------------------------------------------------------------------------=

    @inlinable subscript(position: Index) -> Symbol {
        snapshot[position.snapshot]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traversal
    //=------------------------------------------------------------------------=

    @inlinable func index(after index: Index) -> Index {
        let character = characters[index.character]
        let after = snapshot.index(after: index.snapshot)
        return Index(after, at: index.position.after(character))
    }
    
    @inlinable func index(before index: Index) -> Index {
        let before = snapshot.index(before: index.snapshot)
        let character = characters[before.character]
        return Index(before, at: index.position.before(character))
    }

    //*========================================================================*
    // MARK: * Index
    //*========================================================================*

    @usableFromInline struct Index: Comparable {

        //=------------------------------------------------------------------------=
        // MARK: Properties
        //=------------------------------------------------------------------------=

        @usableFromInline let snapshot: Snapshot.Index
        @usableFromInline let position: Position

        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=

        @inlinable init(_ snapshot: Snapshot.Index, at position: Position) {
            self.snapshot = snapshot
            self.position = position
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
            lhs.position == rhs.position
        }

        @inlinable static func <  (lhs: Self, rhs: Self) -> Bool {
            lhs.position <  rhs.position
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Positions - Move To Destination
//=----------------------------------------------------------------------------=

extension Positions {
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    #warning("rework")
    @inlinable func forwards(start: Index, destination: Position) -> Index {
        var position = start
        
        while position.snapshot != snapshot.endIndex {
            guard position.position < destination else { return position }
            formIndex(after: &position)
        }
        
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    #warning("rework")
    @inlinable func backwards(start: Index, destination: Position) -> Index {
        var position = start
        
        while position.snapshot != snapshot.startIndex {
            let after = position
            formIndex(before: &position)
            guard position.position > destination else { return after }
        }
        
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable func index(start: Index, destination: Position) -> Index {
        start.position <= destination
        ?  forwards(start: start, destination: destination)
        : backwards(start: start, destination: destination)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=

    @inlinable func indices(start: Range<Index>, destination: Range<Position>) -> Range<Index> {
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        var lowerBound = upperBound
        
        if !destination.isEmpty {
            lowerBound = index(start: start.lowerBound, destination: destination.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }

        return lowerBound ..< upperBound
    }
}
