//
//  Layout.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

//*============================================================================*
// MARK: * Layout
//*============================================================================*

/// The text layout, as described by a snapshot.
///
/// This is used to traverse text from the point of view of a caret.
///
/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|x
/// ```
@usableFromInline struct Layout<Scheme: DiffableTextViews.Scheme>: BidirectionalCollection {
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline let snapshot: Snapshot
    @usableFromInline let range: Range<Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.snapshot = snapshot
        self.range = Index(snapshot.startIndex, at: .start) ..<
        Index(snapshot .endIndex, at: .end(of: snapshot.characters))
    }
 
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func nonpassthrough(_ position: Index) -> Bool {
        !snapshot.attributes[position.attribute].contains(.passthrough)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors - Indices
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) var startIndex: Index {
        range.lowerBound
    }
    
    @inlinable @inline(__always) var endIndex: Index {
        range.upperBound
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors - Elements
    //=------------------------------------------------------------------------=

    @inlinable subscript(position: Index) -> Symbol {
        snapshot[position.snapshot]
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

        @inlinable static func  < (lhs: Self, rhs: Self) -> Bool {
            lhs.position  < rhs.position
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Look
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Ahead
    //=------------------------------------------------------------------------=
    
    @inlinable func lookahead(_ position: Index) -> Index? {
        position != endIndex ? position : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Behind
    //=------------------------------------------------------------------------=
    
    @inlinable func lookbehind(_ position: Index) -> Index? {
        position != startIndex ? index(before: position) : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Ahead/Behind
    //=------------------------------------------------------------------------=
    
    @inlinable func look(position: Index, direction: Direction) -> Index? {
        switch direction {
        case  .forwards: return  lookahead(position)
        case .backwards: return lookbehind(position)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Index After/Before
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Next - After
    //=------------------------------------------------------------------------=

    @inlinable func index(after index: Index) -> Index {
        let character = snapshot.characters[index.character]
        let after = snapshot.index(after: index.snapshot)
        return Index(after, at: index.position.after(character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Next - Before
    //=------------------------------------------------------------------------=
    
    @inlinable func index(before index: Index) -> Index {
        let before = snapshot.index(before: index.snapshot)
        let character = snapshot.characters[before.character]
        return Index(before, at: index.position.before(character))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Index After/Before While
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: After
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after start: Index, while predicate: (Index) -> Bool) -> Index {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            guard predicate(position) else { return position }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Position == End Index
        //=--------------------------------------=
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Before
    //=------------------------------------------------------------------------=

    @inlinable func index(before start: Index, while predicate: (Index) -> Bool) -> Index {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            guard predicate(position) else { return position }
            formIndex(before: &position)
        }
        //=--------------------------------------=
        // MARK: Position == Start Index
        //=--------------------------------------=
        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Index At Position
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable func index(start: Index, destination: Position) -> Index {
        start.position <= destination
        ? index(after:  start, while: { $0.position < destination })
        : index(before: start, while: { $0.position > destination })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Destination - Double
    //=------------------------------------------------------------------------=

    @inlinable func indices(start: Range<Index>, destination: Range<Position>) -> Range<Index> {
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !destination.isEmpty {
            lowerBound = index(start: start.lowerBound, destination: destination.lowerBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return lowerBound ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - First Index To/Through
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards - To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsTo(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            if predicate(position) { return position }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards - Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsThrough(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            if predicate(position) { return index(after: position) }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards - To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsTo(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            let after = position
            formIndex(before: &position)
            if predicate(position) { return after }
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards - Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsThrough(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            formIndex(before: &position)
            if predicate(position) { return position }
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards/Backwards - To/Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndex(start: Index, direction: Direction, skip: Bool) -> Index? {
        switch (direction, skip) {
        case (.forwards, false): return firstIndexForwardsTo(start: start, where: nonpassthrough)
        case (.forwards, true): return firstIndexForwardsThrough(start: start, where: nonpassthrough)
        case (.backwards, false): return firstIndexBackwardsTo(start: start, where: nonpassthrough)
        case (.backwards, true): return firstIndexBackwardsThrough(start: start, where: nonpassthrough)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Preferred
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Index
    //=------------------------------------------------------------------------=
    
    /// The preferred index according to preference, intent and attributes.
    ///
    /// - The default index, in case no preferred index is found, is the start index.
    ///
    @inlinable func preferredIndex(start: Layout.Index, preference: Direction, intent: Direction?) -> Layout.Index {
        //=--------------------------------------=
        // MARK: Inspect The Initial Position
        //=--------------------------------------=
        if look(position: start, direction: preference).map(nonpassthrough) == true { return start }
        //=--------------------------------------=
        // MARK: Pick A Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try In This Direction
        //=--------------------------------------=
        if let caret = firstIndex(start: start, direction: direction, skip: direction != preference) { return caret }
        //=--------------------------------------=
        // MARK: Try In The Other Direction
        //=--------------------------------------=
        if let caret = firstIndex(start: start, direction: direction.reversed(), skip: false) { return caret }
        //=--------------------------------------=
        // MARK: Default To The Start Index
        //=--------------------------------------=
        return startIndex
    }
}
