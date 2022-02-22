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
// MARK: + Attributes
//=----------------------------------------------------------------------------=

extension Layout {
 
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func nonlookaheadable(_ position: Index) -> Bool {
        !snapshot.attributes[position.attribute].contains(.lookaheadable)
    }
    
    @inlinable func nonlookbehindable(_ position: Index) -> Bool {
        !snapshot.attributes[position.attribute].contains(.lookbehindable)
    }
    
    @inlinable func nonlookable(_ position: Index, direction: Direction) -> Bool {
        direction == .forwards ? nonlookaheadable(position) : nonlookbehindable(position)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collision
//=----------------------------------------------------------------------------=

extension Layout {

    //=------------------------------------------------------------------------=
    // MARK: Dynamic
    //=------------------------------------------------------------------------=
    
    @inlinable func collision(_ start: Index, direction: Direction, through: Bool) -> Index? {
        switch (direction, through) {
        case (.forwards,  false): return firstIndexForwardsTo(start: start, where: nonlookaheadable)
        case (.forwards,   true): return firstIndexForwardsThrough(start: start, where: nonlookaheadable)
        case (.backwards, false): return firstIndexBackwardsTo(start: start, where: nonlookbehindable)
        case (.backwards,  true): return firstIndexBackwardsThrough(start: start, where: nonlookbehindable)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Preferred
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Index
    //=------------------------------------------------------------------------=
    
    /// The preferred index according to preference, intent and attributes.
    ///
    /// - The default index, in case no preferred index is found, is the start index.
    ///
    @inlinable func preferredIndex(_ start: Layout.Index, preference: Direction, intent: Direction?) -> Layout.Index {
        //=--------------------------------------=
        // MARK: Inspect The Initial Position
        //=--------------------------------------=
        if let preferred = side(start, direction: preference),
        nonlookable(preferred, direction: preference) == true {
            return start
        }
        //=--------------------------------------=
        // MARK: Pick A Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try In This Direction
        //=--------------------------------------=
        if let collision = collision(start, direction: direction, through: direction != preference) {
            return collision
        }
        //=--------------------------------------=
        // MARK: Try In The Other Direction
        //=--------------------------------------=
        if let collision = collision(start, direction: direction.reversed(), through: false) {
            return collision
        }
        //=--------------------------------------=
        // MARK: Default To Layout's Start Index
        //=--------------------------------------=
        return startIndex
    }
}
