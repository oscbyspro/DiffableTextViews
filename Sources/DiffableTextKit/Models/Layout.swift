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

/// The text's layout, used to obtain carets.
///
/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|~
/// ```
///
/// A caret shares index with the character that appears behind it.
/// This makes forwards traversal and backwards traversal asymmetric.
///
public struct Layout<Scheme: DiffableTextKit.Scheme>: BidirectionalCollection {
    @usableFromInline typealias Target = (Index) -> Bool
    @usableFromInline typealias Subindex = Snapshot.Index
    @usableFromInline typealias Position = DiffableTextKit.Position<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline let snapshot: Snapshot
    @usableFromInline let range: Range<Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.snapshot = snapshot
        self.range = Range.init(uncheckedBounds:(
        Index(snapshot.startIndex, at: Position.start),
        Index(snapshot  .endIndex, at: Position.end(of: snapshot.characters))))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Element
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: Index) -> Symbol {
        snapshot[index.subindex]
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
        let after = snapshot.index(after: index.subindex)
        return Index(after, at: index.position.after(character))
    }

    @inlinable public func index(before index: Index) -> Index {
        let before = snapshot.index(before: index.subindex)
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

        @usableFromInline let subindex: Subindex
        @usableFromInline let position: Position

        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        @inlinable init(_ subindex: Subindex, at position: Position) {
            self.subindex = subindex
            self.position = position
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=

        @inlinable var character: String.Index {
            subindex.character
        }
        
        @inlinable var attribute: Int {
            subindex.attribute
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
 
    @inlinable func nonpassthrough(at index: Index) -> Bool {
        !snapshot.attributes[index.attribute].contains(.passthrough)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=

    @inlinable func peek(from index: Index, towards direction: Direction) -> Index? {
        direction == .forwards ? peek(ahead: index) : peek(behind: index)
    }
    
    @inlinable func peek(ahead index: Index) -> Index? {
        index != endIndex ? index : nil
    }

    @inlinable func peek(behind index: Index) -> Index? {
        index != startIndex ? self.index(before: index) : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable func index(of subindex: Subindex) -> Index {
        Index(subindex, at: .end(of: snapshot.characters[..<subindex.character]))
    }

    @inlinable func index(at position: Position, from index: Index) -> Index {
        switch index.position <= position {
        case  true: return self.index(after:  index) { $0.position < position }
        case false: return self.index(before: index) { $0.position > position }
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
    
    /// Returns the preferred caret, or endIndex if no preferred caret was found.
    @inlinable func caret(from index: Index, towards direction: Direction?,
    preferring preference: Direction) -> Index {
        //=--------------------------------------=
        // MARK: Anchor
        //=--------------------------------------=
        if let anchor = snapshot.anchor.map(
        index(of:)) { return anchor }
        //=--------------------------------------=
        // MARK: Inspect Initial Index
        //=--------------------------------------=
        if peek(from: index, towards: preference).map(
        nonpassthrough(at:)) == true { return index }
        //=--------------------------------------=
        // MARK: Direction
        //=--------------------------------------=
        let direction = direction ?? preference
        //=--------------------------------------=
        // MARK: Search In The Direction
        //=--------------------------------------=
        if let caret = caret(from: index,
        towards: direction,
        jumping: direction == preference ? .to : .through,
        targeting: nonpassthrough(at:)) { return caret }
        //=--------------------------------------=
        // MARK: Search In The Other Direction
        //=--------------------------------------=
        if let caret = caret(from: index,
        towards: direction.reversed(),
        jumping: Jump.to, // use Jump.to on each direction
        targeting: nonpassthrough(at:)) { return caret }
        //=--------------------------------------=
        // MARK: Default To Instance End Index
        //=--------------------------------------=
        return self.endIndex
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Forwards / Backwards / To / Through
    //=--------------------------------------------------------------------=
    
    @inlinable func caret(from index: Index, towards direction: Direction,
    jumping distance: Jump, targeting target: Target) -> Index? {
        switch (direction, distance) {
        case (.forwards,  .to     ): return caret(from: index, forwardsTo:       target)
        case (.forwards,  .through): return caret(from: index, forwardsThrough:  target)
        case (.backwards, .to     ): return caret(from: index, backwardsTo:      target)
        case (.backwards, .through): return caret(from: index, backwardsThrough: target)
        }
    }

    @inlinable func caret(from index: Index, forwardsTo target: Target) -> Index? {
        indices[index...].first(where: target)
    }
    
    @inlinable func caret(from index: Index, forwardsThrough target: Target) -> Index? {
        caret(from: index, forwardsTo: target).map(index(after:))
    }

    @inlinable func caret(from index: Index, backwardsTo target: Target) -> Index? {
        caret(from: index, backwardsThrough: target).map(index(after:))
    }
    
    @inlinable func caret(from index: Index, backwardsThrough target: Target) -> Index? {
        indices[..<index].last(where: target)
    }
}
