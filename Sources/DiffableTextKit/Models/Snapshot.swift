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
/// - **Anchor**
///
/// Set the anchor to select the caret represented by its index. It may be desirable
/// on snapshots containing only formatting characters. As an example, a pattern text style
/// bound to an empty value may anchor at the pattern's first placeholder character.
///
/// - **Attributes & Characters**
///
/// The number of attributes must always equal the number of joint characters in the
/// snapshot. A failure to maintain this invariant will result in an invalid state
/// and may crash your application. In most cases, this is a trivial constraint as
/// the easiest and most straight forward way to create a snapshot is to loop over each
/// characters in an already joined sequence.
///
public struct Snapshot: Equatable,
BidirectionalCollection,
RangeReplaceableCollection,
ExpressibleByArrayLiteral,
ExpressibleByStringLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    public typealias Index   = DiffableTextKit.Index
    public typealias Element = DiffableTextKit.Symbol

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @usableFromInline var _characters: String
    @usableFromInline var _attributes: [Attribute]
    @usableFromInline var _anchor: Self.Index?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init() {
        self._characters = ""
        self._attributes = []
    }
    
    @inlinable @inline(__always)
    public init(arrayLiteral  symbols: Symbol...) {
        self.init(symbols)
    }
    
    @inlinable @inline(__always)
    public init(stringLiteral characters: String) {
        self.init(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public var characters: String {
        _characters
    }
    
    @inlinable @inline(__always)
    public var attributes: [Attribute] {
        _attributes
    }
    
    @inlinable @inline(__always)
    public var anchor: Index? {
        _anchor
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func anchorAtEndIndex() {
        self._anchor = endIndex
    }
    
    @inlinable @inline(__always)
    public mutating func anchor(at index: Index?) {
        self._anchor = index
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A lazy sequence of nonvirtual characters.
    @inlinable public var nonvirtuals: some BidirectionalCollection<Character> {
        self.lazy.filter({!$0.attribute.contains(.virtual)}).map({$0.character})
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Initializers
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: String
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init(_ characters: String, as attribute: Attribute = .content) {
        self.init(characters, as: { _ in attribute })
    }
    
    @inlinable @inline(__always)
    public init(_ characters:  String, as attribute: (Character) -> Attribute) {
        self._characters = characters
        self._attributes = []
        
        for character in characters {
            self._attributes.append(attribute(character))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Sequence
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init(_ characters: some Sequence<Character>,
    as attribute: Attribute = .content) {
        self.init(characters, as: { _ in attribute })
    }
    
    @inlinable @inline(__always)
    public init(_ characters: some Sequence<Character>,
    as attribute: (Character) -> Attribute) {
        self.init(); self.append(contentsOf: characters, as: attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Element
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public subscript(position: Index) -> Symbol {
        Symbol(_characters[position.character],
        as:    _attributes[position.attribute])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public var startIndex: Index {
        Index(_characters.startIndex,
        as:   _attributes.startIndex)
    }

    @inlinable @inline(__always)
    public var endIndex: Index {
        Index(_characters.endIndex,
        as:   _attributes.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: After, Before, Distance
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func index(after position: Index) -> Index {
        Index(_characters.index(after: position.character),
        as:   _attributes.index(after: position.attribute))
    }
    
    @inlinable @inline(__always)
    public func index(before position: Index) -> Index {
        Index(_characters.index(before: position.character),
        as:   _attributes.index(before: position.attribute))
    }
    
    @inlinable @inline(__always)
    public func index(_ position: Index, offsetBy distance: Int) -> Index {
        let character = _characters.index(position.character, offsetBy: distance)
        let attribute = _attributes.index(position.attribute, offsetBy: distance)
        return Index(character, as: attribute)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    /// - Complexity: O(1).
    @inlinable @inline(__always)
    public var isEmpty: Bool {
        _attributes.isEmpty
    }
    
    /// - Complexity: O(1).
    @inlinable @inline(__always)
    public var count: Int {
        _attributes.count
    }
    
    /// - Complexity: O(1).
    @inlinable @inline(__always)
    public var underestimatedCount: Int {
        _attributes.underestimatedCount
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func transform(
    attributes position: Index,
    with transform: (inout Attribute) -> Void) {
        transform(&self._attributes[position.attribute])
    }
    
    @inlinable @inline(__always)
    public mutating func transform(
    attributes positions: some Sequence<Index>,
    with transform: (inout Attribute) -> Void) {
        for index in positions {
            transform(&self._attributes[index.attribute])
        }
    }
    
    @inlinable @inline(__always)
    public mutating func transform<R>(
    attributes positions: R,
    with transform: (inout Attribute) -> Void)
    where R: RangeExpression, R.Bound == Index {
        for index in indices[positions.relative(to:self)] {
            transform(&self._attributes[index.attribute])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Append
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func append(_ symbol: Symbol) {
        self._characters.append(symbol.character)
        self._attributes.append(symbol.attribute)
    }
    
    @inlinable @inline(__always)
    public mutating func append(_ character: Character,
    as attribute: Attribute = .content) {
        self.append(Symbol(character, as: attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Append x Sequence
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func append(
    contentsOf characters: some Sequence<Character>,
    as attribute: Attribute = .content) {
        self.append(contentsOf: characters, as: { _ in attribute })
    }
    
    @inlinable @inline(__always)
    public mutating func append(
    contentsOf characters: some Sequence<Character>,
    as attribute: (Character) -> Attribute) {
        for character in characters {
            self._characters.append(character)
            self._attributes.append(attribute(character))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Insert
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func insert(_ symbol: Symbol, at  position: Index) {
        self._characters.insert(symbol.character, at: position.character)
        self._attributes.insert(symbol.attribute, at: position.attribute)
    }
        
    @inlinable @inline(__always)
    public mutating func insert(_ character: Character,
    at position: Index, as attribute: Attribute = .content) {
        self.insert(Symbol(character, as: attribute), at: position)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Insert x Collection
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func insert(contentsOf characters: some Collection<Character>,
    at position: Index, as attribute: Attribute = .content) {
        self.insert(contentsOf: characters, at: position, as: { _ in attribute })
    }
    
    @inlinable @inline(__always)
    public mutating func insert(contentsOf characters: some Collection<Character>,
    at position: Index, as attribute: (Character) -> Attribute) {
        self.replaceSubrange(position..<position, with: characters, as: attribute)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Remove
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) @discardableResult
    public mutating func remove(at position: Index) -> Symbol {
        Symbol(self._characters.remove(at: position.character),
        as:    self._attributes.remove(at: position.attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Replace
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func replaceSubrange(_ positions: Range<Index>,
    with symbols: some Collection<Symbol>) {
        self.replaceSubrange(positions,
        characters: symbols.lazy.map(\.character),
        attributes: symbols.lazy.map(\.attribute))
    }
    
    @inlinable @inline(__always)
    public mutating func replaceSubrange(_ positions: Range<Index>,
    with characters: some Collection<Character>, as attribute: Attribute = .content) {
        self.replaceSubrange(positions, with: characters, as: { _ in attribute })
    }
    
    @inlinable @inline(__always)
    public mutating func replaceSubrange(_ positions: Range<Index>,
    with characters: some Collection<Character>, as attribute: (Character) -> Attribute) {
        self.replaceSubrange(positions,
        characters: characters,
        attributes: characters.lazy.map(attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    mutating func replaceSubrange(_ positions: Range<Index>,
    characters: some Collection<Character>,
    attributes: some Collection<Attribute>) {
        self._characters.replaceSubrange(
        positions.lowerBound.character  ..<
        positions.upperBound.character, with: characters)
        
        self._attributes.replaceSubrange(
        positions.lowerBound.attribute  ..<
        positions.upperBound.attribute, with: attributes)
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
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func nonpassthrough(at position: Index) -> Bool {
        !attributes[position.attribute].contains(.passthrough)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(from position: Index, towards direction: Direction) ->  Index? {
        direction == .forwards ? peek(ahead: position) : peek(behind: position)
    }
    
    @inlinable @inline(__always)
    func peek(ahead position: Index) -> Index? {
        position != endIndex ? position  : nil
    }
    
    @inlinable @inline(__always)
    func peek(behind position: Index) -> Index? {
        position != startIndex ? self.index(before: position) : nil
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Caret
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable public func selection(_ carets: Selection<Detached>) -> Selection<Index> {
        carets.map(self.index(_:))
    }
    
    @inlinable public func index(_ caret: Detached) -> Index {
        //=--------------------------------------=
        // Anchor
        //=--------------------------------------=
        if let anchor { return anchor }
        //=--------------------------------------=
        // Inspect Initial Position
        //=--------------------------------------=
        if let peek = self.peek(
        from: caret.position,
        towards: caret.preference),
        nonpassthrough(at: peek) { return caret.position }
        //=--------------------------------------=
        // Direction
        //=--------------------------------------=
        let direction = caret.momentum ?? caret.preference
        //=--------------------------------------=
        // Search In Direction
        //=--------------------------------------=
        if let index = self.index(
        from: caret.position,
        towards: direction,
        jumping: direction == caret.preference ? .to : .through,
        targeting: nonpassthrough) { return index }
        //=--------------------------------------=
        // Search In Opposite Direction
        //=--------------------------------------=
        if let index = self.index(
        from: caret.position,
        towards: direction.reversed(),
        jumping: Jump.to, // always use Jump.to
        targeting: nonpassthrough) { return index }
        //=--------------------------------------=
        // Return Preference On Caret Not Found
        //=--------------------------------------=
        return caret.preference == .backwards ? startIndex : endIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards, Backwards, To, Through
    //=------------------------------------------------------------------------=
    
    @inlinable func index(from position: Index, towards direction: Direction,
    jumping distance: Jump, targeting target: Target) -> Index? {
        switch (direction, distance) {
        case (.forwards,  .to     ): return index(from: position, forwardsTo:       target)
        case (.forwards,  .through): return caret(from: position, forwardsThrough:  target)
        case (.backwards, .to     ): return index(from: position, backwardsTo:      target)
        case (.backwards, .through): return index(from: position, backwardsThrough: target)
        }
    }
    
    @inlinable @inline(__always)
    func index(from position: Index, forwardsTo target: Target) -> Index? {
        indices[position...].first(where: target)
    }
    
    @inlinable @inline(__always)
    func caret(from position: Index, forwardsThrough target: Target) -> Index? {
        index(from: position, forwardsTo: target).map(self.index(after:))
    }
    
    @inlinable @inline(__always)
    func index(from position: Index, backwardsTo target: Target) -> Index? {
        index(from: position, backwardsThrough: target).map(self.index(after:))
    }
    
    @inlinable @inline(__always)
    func index(from position: Index, backwardsThrough target: Target) -> Index? {
        indices[..<position].last(where: target)
    }
    
    //*========================================================================*
    // MARK: * Types(s)
    //*========================================================================*

    @usableFromInline enum Jump { case to, through }
    
    @usableFromInline typealias Target = (Index) -> Bool
    
    public typealias Detached = DiffableTextKit.Detached<Index>
}
