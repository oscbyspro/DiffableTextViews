//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Layout
//*============================================================================*

/// The text layout, as described by a snapshot and its attributes.
///
/// It is used to traverse text from the point of view of one or more carets.
///
/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|x
/// ```
@usableFromInline struct Layout<Scheme: DiffableTextViews.Scheme>: BidirectionalCollection {
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline let snapshot: Snapshot
    @usableFromInline let range: Range<Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.snapshot = Snapshot()
        let startIndex = Index(snapshot.startIndex, at: .start)
        self.range = startIndex ..< startIndex
    }
    
    @inlinable init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
        self.range = Index(snapshot.startIndex, at: .start) ..<
        Index(snapshot.endIndex, at: .end(of: snapshot.characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
 
    @inlinable func nonpassthrough(_ position: Index) -> Bool {
        !snapshot.attributes[position.attribute].contains(.passthrough)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        range.lowerBound
    }
    
    @inlinable var endIndex: Index {
        range.upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Elements
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Symbol {
        snapshot[position.snapshot]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traversals
    //=------------------------------------------------------------------------=

    @inlinable func index(after index: Index) -> Index {
        let character = snapshot.characters[index.character]
        let after = snapshot.index(after: index.snapshot)
        return Index(after, at: index.position.after(character))
    }

    @inlinable func index(before index: Index) -> Index {
        let before = snapshot.index(before: index.snapshot)
        let character = snapshot.characters[before.character]
        return Index(before, at: index.position.before(character))
    }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*

    @usableFromInline struct Index: Comparable {

        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        @usableFromInline let snapshot: Snapshot.Index
        @usableFromInline let position: Position

        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        @inlinable init(_ snapshot: Snapshot.Index, at position: Position) {
            self.snapshot = snapshot
            self.position = position
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=

        @inlinable var character: String.Index {
            snapshot.character
        }
        
        @inlinable var attribute: Int {
            snapshot.attribute
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=

        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.position == rhs.position
        }
        
        @inlinable static func <  (lhs: Self, rhs: Self) -> Bool {
            lhs.position <  rhs.position
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Snapshot
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(_ start: Range<Index>, destination: Snapshot.Index) -> Range<Index> {
        let upper = destination.attribute - start.upperBound.attribute
        let lower = destination.attribute - start.lowerBound.attribute
        //=--------------------------------------=
        // MARK: Compare
        //=--------------------------------------=
        let position = upper <= lower
        ? index(start.upperBound, offsetBy: upper)
        : index(start.lowerBound, offsetBy: lower)
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return position ..< position
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Position
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
// MARK: + While
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
        // MARK: Position == Layout End Index
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
        // MARK: Position == Layout Start Index
        //=--------------------------------------=
        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Search
//=----------------------------------------------------------------------------=

extension Layout {

    //=------------------------------------------------------------------------=
    // MARK: Forwards To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsTo(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            if predicate(position) { return position }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsThrough(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            if predicate(position) { return index(after: position) }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsTo(from start: Index, where predicate: (Index) -> Bool) -> Index? {
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
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsThrough(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            formIndex(before: &position)
            if predicate(position) { return position }
        }
        //=--------------------------------------=
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards / Backwards / To / Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndex(start: Index, direction: Direction, through: Bool) -> Index? {
        switch (direction, through) {
        case (.forwards,  false): return firstIndexForwardsTo(from:       start, where: nonpassthrough)
        case (.forwards,   true): return firstIndexForwardsThrough(from:  start, where: nonpassthrough)
        case (.backwards, false): return firstIndexBackwardsTo(from:      start, where: nonpassthrough)
        case (.backwards,  true): return firstIndexBackwardsThrough(from: start, where: nonpassthrough)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Peek
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Ahead
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(ahead position: Index) -> Index? {
        position != endIndex ? position : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Behind
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(behind position: Index) -> Index? {
        position != startIndex ? index(before: position) : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Ahead / Behind
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(_ position: Index, direction: Direction) -> Index? {
        direction == .forwards ? peek(ahead: position) : peek(behind: position)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Preference
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable func preferredIndex(start: Layout.Index, preference: Direction, intent: Direction?) -> Layout.Index {
        //=--------------------------------------=
        // MARK: Inspect The Initial Position
        //=--------------------------------------=
        if peek(start, direction: preference).map(nonpassthrough) == true { return start }
        //=--------------------------------------=
        // MARK: Pick A Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try In This Direction
        //=--------------------------------------=
        if let index = firstIndex(start: start, direction: direction, through: direction != preference) { return index }
        //=--------------------------------------=
        // MARK: Try In The Other Direction
        //=--------------------------------------=
        if let index = firstIndex(start: start, direction: direction.reversed(), through: false) { return index }
        //=--------------------------------------=
        // MARK: Return Layout Start Index
        //=--------------------------------------=
        return startIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=
    
    @inlinable func preferredIndices(start: Range<Index>, intent: Intent) -> Range<Index> {
        //=--------------------------------------=
        // MARK: Anchor
        //=--------------------------------------=
        if let anchorIndex = snapshot.anchorIndex {
            return indices(start, destination: anchorIndex)
        }
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = preferredIndex(start: start.upperBound, preference: .backwards, intent: intent.upper)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !start.isEmpty, upperBound != startIndex {
            lowerBound = preferredIndex(start: start.lowerBound, preference:  .forwards, intent: intent.lower)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return lowerBound ..< upperBound
    }
}
