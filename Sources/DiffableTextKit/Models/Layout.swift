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
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|~
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

    @inlinable public func index(after index: Index) -> Index {
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
    // MARK: Subindex
    //=------------------------------------------------------------------------=
    
    /// Should be faster than iterating considering that UTF16 characters size count is O(1).
    @inlinable func index(of subindex: Snapshot.Index) -> Index {
        Index(subindex, at: .end(of: snapshot.characters[..<subindex.character]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Position
    //=------------------------------------------------------------------------=
    
    @inlinable func index(at position: Position, start: Index) -> Index {
        switch start.position <= position {
        case  true: return index(after:  start, while: { $0.position < position })
        case false: return index(before: start, while: { $0.position > position })
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Peek
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(towards direction: Direction, from position: Index) -> Index? {
        direction == .forwards ? peek(ahead: position) : peek(behind: position)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(ahead position: Index) -> Index? {
        position != endIndex ? position : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(behind position: Index) -> Index? {
        position != startIndex ? index(before: position) : nil
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Caret
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Preferred
    //=------------------------------------------------------------------------=
    
    @inlinable func caret(start: Layout.Index, preference: Direction, momentum: Direction?) -> Layout.Index {
        //=--------------------------------------=
        // MARK: Anchor
        //=--------------------------------------=
        if let anchorIndex = snapshot.anchorIndex {
            return index(of: anchorIndex)
        }
        //=--------------------------------------=
        // MARK: Inspect The Initial Position
        //=--------------------------------------=
        if peek(towards: preference, from: start).map(nonpassthrough) == true {
            return start
        }
        //=--------------------------------------=
        // MARK: Pick A Direction
        //=--------------------------------------=
        let direction = momentum ?? preference
        //=--------------------------------------=
        // MARK: Try In This Direction
        //=--------------------------------------=
        if let position = caret(start: start, direction: direction, through: direction != preference) {
            return position
        }
        //=--------------------------------------=
        // MARK: Try In The Other Direction
        //=--------------------------------------=
        if let position = caret(start: start, direction: direction.reversed(), through: false) {
            return position
        }
        //=--------------------------------------=
        // MARK: Return Layout Start Index
        //=--------------------------------------=
        return startIndex
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Direction
    //=--------------------------------------------------------------------=
    
    @inlinable func caret(start: Index, direction: Direction, through: Bool) -> Index? {
        switch (direction, through) {
        case (.forwards,  false): return caret(from: start, forwardsTo:       nonpassthrough)
        case (.forwards,   true): return caret(from: start, forwardsThrough:  nonpassthrough)
        case (.backwards, false): return caret(from: start, backwardsTo:      nonpassthrough)
        case (.backwards,  true): return caret(from: start, backwardsThrough: nonpassthrough)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func caret(from start: Index, forwardsTo predicate: (Index) -> Bool) -> Index? {
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
    
    @inlinable func caret(from start: Index, forwardsThrough predicate: (Index) -> Bool) -> Index? {
        caret(from: start, forwardsTo: predicate).map(index(after:))
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Backwards
    //=--------------------------------------------------------------------=
    
    @inlinable func caret(from start: Index, backwardsTo predicate: (Index) -> Bool) -> Index? {
        caret(from: start, backwardsThrough: predicate).map(index(after:))
    }
    
    @inlinable func caret(from start: Index, backwardsThrough predicate: (Index) -> Bool) -> Index? {
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
}
