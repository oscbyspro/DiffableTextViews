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

/// The text's layout, used to obtain caret positions.
///
/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|~
/// ```
///
/// A caret shares its index with the character that appears behind it.
/// This makes forwards traversal and backwards traversal asymmetric.
///
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
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
 
    @inlinable func nonpassthrough(_ position: Index) -> Bool {
        !snapshot.attributes[position.attribute].contains(.passthrough)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=

    @inlinable func peek(from position: Index, towards direction: Direction) -> Index? {
        direction == .forwards ? peek(ahead: position) : peek(behind: position)
    }
    
    @inlinable func peek(ahead position: Index) -> Index? {
        position != endIndex ? position : nil
    }

    @inlinable func peek(behind position: Index) -> Index? {
        position != startIndex ? index(before: position) : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interoperabilities
    //=------------------------------------------------------------------------=
    
    /// Should be faster than iterating considering that UTF16 characters size count is O(1).
    @inlinable func index(of subindex: Snapshot.Index) -> Index {
        Index(subindex, at: .end(of: snapshot.characters[..<subindex.character]))
    }

    @inlinable func index(at position: Position, from start: Index) -> Index {
        switch start.position <= position {
        case  true: return index(after:  start, while: { $0.position < position })
        case false: return index(before: start, while: { $0.position > position })
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Caret
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Preferred
    //=------------------------------------------------------------------------=
    
    @inlinable func caret(from position: Layout.Index, towards direction: Direction?,
    preferring preference: Direction) -> Layout.Index {
        //=--------------------------------------=
        // MARK: Anchor
        //=--------------------------------------=
        if let anchor = snapshot.anchor.map(
        index) { return anchor }
        //=--------------------------------------=
        // MARK: Inspect The Initial Position
        //=--------------------------------------=
        if peek(from: position, towards: preference).map(
        nonpassthrough) == true { return position }
        //=--------------------------------------=
        // MARK: Direction
        //=--------------------------------------=
        let direction = direction ?? preference
        //=--------------------------------------=
        // MARK: Search In The Direction
        //=--------------------------------------=
        if let caret = caret(from: position,
        towards: direction,
        jumping: direction == preference ? .to : .through,
        targeting: nonpassthrough) { return caret }
        //=--------------------------------------=
        // MARK: Search In The Other Direction
        //=--------------------------------------=
        // NOTE: direction.reversed() != preference uses Jump.to.
        // This is because there were no nonpassthrough positions
        // in the preferred direction and the correct behavior is
        // therefore: jump to the nearest nonpassthrough position
        if let caret = caret(from: position,
        towards: direction.reversed(),
        jumping: Jump.to, // read the above comment
        targeting: nonpassthrough) { return caret }
        //=--------------------------------------=
        // MARK: Return Layout Start Index
        //=--------------------------------------=
        return self.startIndex
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Adaptive
    //=--------------------------------------------------------------------=
    
    @inlinable func caret(from position: Index, towards direction: Direction,
    jumping distance: Jump, targeting target: (Index) -> Bool) -> Index? {
        switch (direction, distance) {
        case (.forwards,  .to     ): return caret(from: position, forwardsTo:       target)
        case (.forwards,  .through): return caret(from: position, forwardsThrough:  target)
        case (.backwards, .to     ): return caret(from: position, backwardsTo:      target)
        case (.backwards, .through): return caret(from: position, backwardsThrough: target)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func caret(from position: Index,
    forwardsTo target: (Index) -> Bool) -> Index? {
        var position = position
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            if target(position) { return position }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Absent
        //=--------------------------------------=
        return nil
    }
    
    @inlinable func caret(from position: Index,
    forwardsThrough target: (Index) -> Bool) -> Index? {
        //=--------------------------------------=
        // MARK: One After Caret Forwards To
        //=--------------------------------------=
        caret(from: position, forwardsTo: target).map(index(after:))
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Backwards
    //=--------------------------------------------------------------------=
    
    @inlinable func caret(from position: Index,
    backwardsTo target: (Index) -> Bool) -> Index? {
        //=--------------------------------------=
        // MARK: One After Caret Backwards Through
        //=--------------------------------------=
        caret(from: position, backwardsThrough: target).map(index(after:))
    }
    
    @inlinable func caret(from position: Index,
    backwardsThrough target: (Index) -> Bool) -> Index? {
        var position = position
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            formIndex(before: &position)
            if target(position) { return position }
        }
        //=--------------------------------------=
        // MARK: Absent
        //=--------------------------------------=
        return nil
    }
}
