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
/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|x
/// ```
public struct Layout<Scheme: DiffableTextKit.Scheme>: BidirectionalCollection {
    @usableFromInline typealias Position = DiffableTextKit.Position<Scheme>
    
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
    // MARK: Element
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(position: Index) -> Symbol {
        snapshot[position.snapshot]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Index {
        range.lowerBound
    }
    
    @inlinable public var endIndex: Index {
        range.upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: After / Before
    //=------------------------------------------------------------------------=

    @inlinable public func index(after  index: Index) -> Index {
        let character = snapshot.characters[index.character]
        let after = snapshot.index(after: index.snapshot)
        return Index(after, at: index.position.after(character))
    }

    @inlinable public func index(before index: Index) -> Index {
        let before = snapshot.index(before: index.snapshot)
        let character = snapshot.characters[before.character]
        return Index(before, at: index.position.before(character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
 
    @inlinable func nonpassthrough(_ position: Index) -> Bool {
        !snapshot.attributes[position.attribute].contains(.passthrough)
    }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*

    public struct Index: Comparable {

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

        @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.position == rhs.position
        }
        
        @inlinable public static func <  (lhs: Self, rhs: Self) -> Bool {
            lhs.position <  rhs.position
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Indices
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// Should be faster than iterating considering that UTF16 characters size count is O(1).
    @inlinable func index(_ destination: Snapshot.Index) -> Index {
        Index(destination, at: .end(of: snapshot.characters[..<destination.character]))
    }
    
    /// Should be faster than iterating considering that UTF16 characters size count is O(1).
    @inlinable func indices(_ destination: Snapshot.Index) -> Range<Index> {
        let position = index(destination); return position ..< position
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
        switch direction {
        case  .forwards: return peek(ahead:  position)
        case .backwards: return peek(behind: position)
        }
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
        switch start.position <= destination {
        case  true: return index(after:  start, while: { $0.position < destination })
        case false: return index(before: start, while: { $0.position > destination })
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=

    @inlinable func indices(start: Range<Index>, destination: Range<Position>) -> Range<Index> {
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        if destination.isEmpty { return upperBound ..< upperBound }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return index(start: start.lowerBound, destination: destination.lowerBound) ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Preference
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred(_ start: Layout.Index, preference: Direction, momentum: Direction?) -> Layout.Index {
        //=--------------------------------------=
        // MARK: Anchor
        //=--------------------------------------=
        if let anchorIndex = snapshot.anchorIndex {
            return index(anchorIndex)
        }
        //=--------------------------------------=
        // MARK: Inspect The Initial Position
        //=--------------------------------------=
        if peek(start, direction: preference).map(nonpassthrough) == true {
            return start
        }
        //=--------------------------------------=
        // MARK: Pick A Direction
        //=--------------------------------------=
        let direction = momentum ?? preference
        //=--------------------------------------=
        // MARK: Try In This Direction
        //=--------------------------------------=
        if let position = firstCaret(start, direction: direction, through: direction != preference) {
            return position
        }
        //=--------------------------------------=
        // MARK: Try In The Other Direction
        //=--------------------------------------=
        if let position = firstCaret(start, direction: direction.reversed(), through: false) {
            return position
        }
        //=--------------------------------------=
        // MARK: Return Layout Start Index
        //=--------------------------------------=
        return startIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred(_ start: Range<Index>, momentum: Momentum) -> Range<Index> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = preferred(start.upperBound, preference: .backwards, momentum: momentum.upper)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !start.isEmpty, upperBound != startIndex {
            lowerBound = preferred(start.lowerBound, preference:  .forwards, momentum: momentum.lower)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return lowerBound ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Search
//=----------------------------------------------------------------------------=

extension Layout {

    //=------------------------------------------------------------------------=
    // MARK: Forwards To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretForwardsTo(from start: Index, where predicate: (Index) -> Bool) -> Index? {
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
    
    @inlinable func firstCaretForwardsThrough(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        firstCaretForwardsTo(from: start, where: predicate).map(index(after:))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretBackwardsTo(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        firstCaretBackwardsThrough(from: start, where: predicate).map(index(after:))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretBackwardsThrough(from start: Index, where predicate: (Index) -> Bool) -> Index? {
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
    
    @inlinable func firstCaret(_ start: Index, direction: Direction, through: Bool) -> Index? {
        switch (direction, through) {
        case (.forwards,  false): return firstCaretForwardsTo(from:       start, where: nonpassthrough)
        case (.forwards,   true): return firstCaretForwardsThrough(from:  start, where: nonpassthrough)
        case (.backwards, false): return firstCaretBackwardsTo(from:      start, where: nonpassthrough)
        case (.backwards,  true): return firstCaretBackwardsThrough(from: start, where: nonpassthrough)
        }
    }
}
