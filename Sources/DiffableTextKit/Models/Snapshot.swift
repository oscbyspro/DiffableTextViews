//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Snapshot
//*============================================================================*

/// A collection of characters, attributes and an optional anchor.
///
/// ```
/// |$|1|2|3|,|4|5|6|.|7|8|9|_|U|S|D|~
/// |x|o|o|o|x|o|o|o|o|o|o|o|x|x|x|x|~
/// ```
///
/// Set the anchor to select the caret represented by its index. It may be desirable
/// on snapshots containing only formatting characters. As an example, a pattern text style
/// bound to an empty value may anchor at the pattern's first placeholder character.
///
/// On another note, the number of attributes in the snapshot must always equal
/// the number of characters in its storage string. This is usually a trivial invariant
/// to maintain, but failure to maintain it will lead to unexpected behavior.
///
public struct Snapshot: BidirectionalCollection, RangeReplaceableCollection {
    @usableFromInline typealias Target = (Index) -> Bool

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @usableFromInline var _characters: String
    @usableFromInline var _attributes: [Attribute]
    @usableFromInline var _anchor: Self.Index?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init() {
        self._characters = ""
        self._attributes = []
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var characters: String {
        _characters
    }
    
    @inlinable public var attributes: [Attribute] {
        _attributes
    }
    
    @inlinable public var anchor: Index? {
        _anchor
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func anchorAtEndIndex() {
        self._anchor = endIndex
    }
    
    @inlinable public mutating func anchor(at index: Index?) {
        self._anchor = index
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Initializers
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ characters: String, as attribute: Attribute = .content) {
        self.init(characters, as: { _ in attribute })
    }
    
    @inlinable public init(_ characters: some Sequence<Character>, as attribute: Attribute = .content) {
        self.init(characters, as: { _ in attribute })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ characters: String, as attribute: (Character) -> Attribute) {
        self._characters = characters
        self._attributes = []
        
        for character in characters {
            self._attributes.append(attribute(character))
        }
    }
    
    @inlinable public init(_ characters: some Sequence<Character>, as attribute: (Character) -> Attribute) {
        self.init()
        
        for character in characters {
            self._characters.append(character)
            self._attributes.append(attribute(character))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Element
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: Index) -> Symbol {
        Symbol(_characters[index.character],
        as:    _attributes[index.attribute])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Index {
        Index(_characters.startIndex,
        as:   _attributes.startIndex)
    }

    @inlinable public var endIndex: Index {
        Index(_characters.endIndex,
        as:   _attributes.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: After, Before
    //=------------------------------------------------------------------------=
    
    @inlinable public func index(after  index: Index) -> Index {
        Index(_characters .index(after: index.character),
        as:   _attributes .index(after: index.attribute))
    }
    
    @inlinable public func index(before  index: Index) -> Index {
        Index(_characters .index(before: index.character),
        as:   _attributes .index(before: index.attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    /// - Complexity: O(1).
    @inlinable public var isEmpty: Bool {
        _attributes.isEmpty
    }
    
    /// - Complexity: O(1).
    @inlinable public var count: Int {
        _attributes.count
    }
    
    /// - Complexity: O(1).
    @inlinable public var underestimatedCount: Int {
        _attributes.underestimatedCount
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func transform(attributes index: Index,
    with transform: (inout Attribute) -> Void) {
        transform(&_attributes[index.attribute])
    }
    
    @inlinable public mutating func transform(attributes indices: some Sequence<Index>,
    with transform: (inout Attribute) -> Void) {
        for index in indices {
            transform(&_attributes[index.attribute])
        }
    }
    
    @inlinable public mutating func transform<R>(attributes indices: R,
    with transform: (inout Attribute) -> Void)
    where R: RangeExpression, R.Bound == Index {
        for index in self.indices[indices.relative(to: self)] {
            transform(&_attributes[index.attribute])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Replace
    //=------------------------------------------------------------------------=

    @inlinable public mutating func replaceSubrange(_ indices: Range<Index>,
    with elements: some Collection<Symbol>) {
        _characters.replaceSubrange(
        indices.lowerBound.character ..<
        indices.upperBound.character,
        with: elements.lazy.map(\.character))
        
        _attributes.replaceSubrange(
        indices.lowerBound.attribute ..<
        indices.upperBound.attribute,
        with: elements.lazy.map(\.attribute))
    }
    
    @inlinable public mutating func append(_ element: Symbol) {
        _characters.append(element.character)
        _attributes.append(element.attribute)
    }
    
    @inlinable public mutating func append(contentsOf elements: some Sequence<Symbol>) {
        _characters.append(contentsOf: elements.lazy.map(\.character))
        _attributes.append(contentsOf: elements.lazy.map(\.attribute))
    }
    
    @inlinable public mutating func insert(_ element: Element, at index: Index) {
        _characters.insert(element.character, at: index.character)
        _attributes.insert(element.attribute, at: index.attribute)
    }
    
    @inlinable public mutating func insert(contentsOf elements: some Collection<Symbol>, at index: Index) {
        _characters.insert(contentsOf: elements.lazy.map(\.character), at: index.character)
        _attributes.insert(contentsOf: elements.lazy.map(\.attribute), at: index.attribute)
    }
    
    @inlinable @discardableResult public mutating func remove(at index: Index) -> Symbol {
        Symbol(_characters.remove(at: index.character),
        as:    _attributes.remove(at: index.attribute))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Descriptions
//=----------------------------------------------------------------------------=

extension Snapshot: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "\(Self.self)(\"\(_characters)\", \(_attributes))"
    }
}

//=----------------------------------------------------------------------------=
// All extensions below this line are internal implementation details.
//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Passthrough
    //=------------------------------------------------------------------------=
    
    @inlinable func nonpassthrough(at index: Index) -> Bool {
        !attributes[index.attribute].contains(.passthrough)
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
    // MARK: Position
    //=------------------------------------------------------------------------=
    
    @inlinable func index<T>(at position: Position<T>) -> Index {
        T.index(at: position, in: characters)
    }
    
    @inlinable func position<T>(at index: Index) -> Position<T> {
        T.position(at: index, in: characters)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Caret
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Preference
    //=------------------------------------------------------------------------=
    
    /// Returns the preferred caret if it exists, returns endIndex otherwise.
    @inlinable func caret(from index: Index, towards direction: Direction?,
    preferring preference: Direction) -> Index {
        //=--------------------------------------=
        // Anchor
        //=--------------------------------------=
        if let anchor { return anchor }
        //=--------------------------------------=
        // Inspect Initial Index
        //=--------------------------------------=
        if peek(from: index, towards: preference).map(
        nonpassthrough(at:)) == true { return index }
        //=--------------------------------------=
        // Direction
        //=--------------------------------------=
        let direction = direction ?? preference
        //=--------------------------------------=
        // Search In Direction
        //=--------------------------------------=
        if let caret = caret(from: index,
        towards: direction,
        jumping: direction == preference ? .to : .through,
        targeting: nonpassthrough(at:)) { return caret }
        //=--------------------------------------=
        // Search In Other Direction
        //=--------------------------------------=
        if let caret = caret(from: index,
        towards: direction.reversed(),
        jumping: Jump.to, // use Jump.to on each direction
        targeting: nonpassthrough(at:)) { return caret }
        //=--------------------------------------=
        // Return End Index On Caret Not Found
        //=--------------------------------------=
        return self.endIndex
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Forwards, Backwards, To, Through
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
    
    //*========================================================================*
    // MARK: * Jump
    //*========================================================================*

    @usableFromInline enum Jump { case to, through }
}
