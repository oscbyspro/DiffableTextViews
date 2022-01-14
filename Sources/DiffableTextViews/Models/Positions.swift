//
//  Positions.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

//*============================================================================*
// MARK: * Positions
//*============================================================================*

/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|x
/// ```
///
/// - Methods prefixed as move treat indices as is, whereas methods prefixed as look treat indices from the caret's point of view.
/// As such, they behave the same way forwards and differently backwards — since a carets position is in front of its index.
///
///
@usableFromInline struct Positions<Scheme: DiffableTextViews.Scheme>: BidirectionalCollection {
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

#warning("WIP")
#warning("WIP")
#warning("WIP")

extension Positions {
    
    @inlinable func nonpassthrough(_ symbol: Symbol) -> Bool {
        !symbol.attribute.contains(.passthrough)
    }
    
    @inlinable func nonpassthrough(_ position: Index) -> Bool {
        !attributes[position.attribute].contains(.passthrough)
    }
    
    
    @inlinable func stop(at position: Index, direction: Direction) -> Bool {
        switch direction {
        case  .forwards: return position !=   endIndex ? nonpassthrough(position) : false
        case .backwards: return position != startIndex ? nonpassthrough(index(before: position)) : false
        }
    }
    
    @inlinable func stop(start position: Index, direction: Direction) -> Index? {
        switch direction {
        case .forwards:  return self[position...].firstIndex(where: nonpassthrough)
        case .backwards: return self[..<position] .lastIndex(where: nonpassthrough)
        }
    }

}


struct Peek {
    
    let  forwards: Attribute
    let backwards: Attribute
    
    
    
}
