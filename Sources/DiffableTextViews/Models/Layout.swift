//
//  Layout.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

//*============================================================================*
// MARK: * Layout
//*============================================================================*

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
    
    @inlinable func nonpassthrough(_ position: Index) -> Bool {
        !attributes[position.attribute].contains(.passthrough)
    }

    //=------------------------------------------------------------------------=
    // MARK: Elements
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

        @inlinable static func <  (lhs: Self, rhs: Self) -> Bool {
            lhs.position <  rhs.position
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Traversal
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Next - After
    //=------------------------------------------------------------------------=

    @inlinable func index(after index: Index) -> Index {
        let character = characters[index.character]
        let after = snapshot.index(after: index.snapshot)
        return Index(after, at: index.position.after(character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Next - Before
    //=------------------------------------------------------------------------=
    
    @inlinable func index(before index: Index) -> Index {
        let before = snapshot.index(before: index.snapshot)
        let character = characters[before.character]
        return Index(before, at: index.position.before(character))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Traversal
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Predicate - After
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after start: Index, while predicate: (Index) -> Bool) -> Index {
        var position = start
        //=--------------------------------------=
        while position != endIndex {
            guard predicate(position) else { return position }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Predicate - Before
    //=------------------------------------------------------------------------=

    @inlinable func index(before start: Index, while predicate: (Index) -> Bool) -> Index {
        var position = start
        //=--------------------------------------=
        while position != startIndex {
            guard predicate(position) else { return position }
            formIndex(before: &position)
        }
        //=--------------------------------------=
        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Index
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
    // MARK: Double
    //=------------------------------------------------------------------------=

    @inlinable func indices(start: Range<Index>, destination: Range<Position>) -> Range<Index> {
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        var lowerBound = upperBound
        
        if !destination.isEmpty {
            lowerBound = index(start: start.lowerBound, destination: destination.lowerBound)
        }
        
        return lowerBound ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Validation
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Preference - Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func preferableForwards(position: Index) -> Bool {
        position != endIndex ? nonpassthrough(position) : false
    }
    
    @inlinable func preferableBackwards(position: Index) -> Bool {
        position != startIndex ? nonpassthrough(index(before: position)) : false
    }
    
    @inlinable func preferable(position: Index, by preference: Direction) -> Bool {
        switch preference {
        case .forwards: return preferableForwards(position: position)
        case .backwards: return preferableBackwards(position: position)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Layout - Caret
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards - To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretForwardsTo(start: Index) -> Index? {
        var position = start
        
        while position != endIndex {
            if nonpassthrough(position) { return position }
            formIndex(after: &position)
        }
        
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards - Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretForwardsThrough(start: Index) -> Index? {
        var position = start
        
        while position != endIndex {
            if nonpassthrough(position) { return index(after: position) }
            formIndex(after: &position)
        }
        
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards - To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretBackwardsTo(start: Index) -> Index? {
        var position = start

        while position != startIndex {
            let after = position
            formIndex(before: &position)
            if nonpassthrough(position) { return after }
        }

        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards - Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretBackwardsThrough(start: Index) -> Index? {
        var position = start

        while position != startIndex {
            formIndex(before: &position)
            if nonpassthrough(position) { return position }
        }

        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic - Direction, Skip
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaret(start: Index, direction: Direction, skip: Bool) -> Index? {
        switch (direction, skip) {
        case (.forwards, false): return firstCaretForwardsTo(start: start)
        case (.forwards, true): return firstCaretForwardsThrough(start: start)
        case (.backwards, false): return firstCaretBackwardsTo(start: start)
        case (.backwards, true): return firstCaretBackwardsThrough(start: start)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Positions - Caret
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Caret
    //=------------------------------------------------------------------------=
        
    @inlinable func caret(start: Index, preference: Direction, intent: Direction?) -> Index {
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        if preferable(
            position: start,
            by: preference) {
            return start
        }
        //=--------------------------------------=
        // MARK: Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try
        //=--------------------------------------=
        if let caret = firstCaret(
            start: start,
            direction: direction,
            skip: direction != preference) {
            return caret
        }
        //=--------------------------------------=
        // MARK: Try In Reverse Direction
        //=--------------------------------------=
        if let caret = firstCaret(
            start: start,
            direction: direction.reversed(),
            skip: false) {
            return caret
        }
        //=--------------------------------------=
        // MARK: Default
        //=--------------------------------------=
        return startIndex
    }
}
