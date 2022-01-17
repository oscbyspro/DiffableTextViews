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
    // MARK: Subscripts
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
// MARK: Layout - Index After/Before While
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: After
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
    // MARK: Before
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
        
        if !destination.isEmpty {
            lowerBound = index(start: start.lowerBound, destination: destination.lowerBound)
        }
        
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
        
        while position != endIndex {
            if predicate(position) { return position }
            formIndex(after: &position)
        }
        
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards - Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsThrough(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        
        while position != endIndex {
            if predicate(position) { return index(after: position) }
            formIndex(after: &position)
        }
        
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards - To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsTo(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start

        while position != startIndex {
            let after = position
            formIndex(before: &position)
            if predicate(position) { return after }
        }

        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards - Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsThrough(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start

        while position != startIndex {
            formIndex(before: &position)
            if predicate(position) { return position }
        }
        
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

#warning("Maybe this belongs in State model.")

//=----------------------------------------------------------------------------=
// MARK: Layout - Autocorrect
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Caret -
    //=------------------------------------------------------------------------=
        
    @inlinable func position(start: Index, preference: Direction, intent: Direction?) -> Index {
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        if validate(position: start, preference: preference) { return start }
        //=--------------------------------------=
        // MARK: Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try
        //=--------------------------------------=
        if let caret = firstIndex(start: start, direction: direction, skip: direction != preference) { return caret }
        //=--------------------------------------=
        // MARK: Try In Reverse Direction
        //=--------------------------------------=
        if let caret = firstIndex(start: start, direction: direction.reversed(), skip: false) { return caret }
        //=--------------------------------------=
        // MARK: Default
        //=--------------------------------------=
        return startIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Caret - Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(position: Index, preference: Direction) -> Bool {
        switch preference {
        case  .forwards: return  lookahead(position).map(nonpassthrough) ?? false
        case .backwards: return lookbehind(position).map(nonpassthrough) ?? false
        }
    }
}
