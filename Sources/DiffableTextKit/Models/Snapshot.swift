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
    public init(arrayLiteral symbols: Symbol...) {
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
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// A lazy sequence of nonvirtual characters.
    @inlinable public var nonvirtuals: some BidirectionalCollection<Character> {
        self.lazy.filter({!$0.attribute.contains(.virtual)}).map({$0.character})
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
    public init(_ characters: String, as attribute: (Character) -> Attribute) {
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
    public init(_ characters: some Sequence<Character>, as attribute: Attribute = .content) {
        self.init(characters, as: { _ in attribute })
    }
    
    @inlinable @inline(__always)
    public init(_ characters: some Sequence<Character>, as attribute: (Character) -> Attribute) {
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
    public subscript(index: Index) -> Symbol {
        Symbol(_characters[index.character],
        as:    _attributes[index.attribute])
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
    
    @inlinable @inline(__always)
    var defaultIndex: Index {
        self.endIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: After, Before, Distance
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func index(after index: Index) -> Index {
        Index(_characters.index(after: index.character),
        as:   _attributes.index(after: index.attribute))
    }
    
    @inlinable @inline(__always)
    public func index(before index: Index) -> Index {
        Index(_characters.index(before: index.character),
        as:   _attributes.index(before: index.attribute))
    }
    
    @inlinable @inline(__always)
    public func index(_ index: Index, offsetBy distance: Int) -> Index {
        let character = _characters.index(index.character, offsetBy: distance)
        let attribute = _attributes.index(index.attribute, offsetBy: distance)
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
    public mutating func transform(attributes index: Index,
    with transform: (inout Attribute) -> Void) {
        transform(&self._attributes[index.attribute])
    }
    
    @inlinable @inline(__always)
    public mutating func transform(attributes indices: some Sequence<Index>,
    with transform: (inout Attribute) -> Void) {
        for index in indices {
            transform(&self._attributes[index.attribute])
        }
    }
    
    @inlinable @inline(__always)
    public mutating func transform<R>(attributes indices: R,
    with transform: (inout Attribute) -> Void)
    where R: RangeExpression, R.Bound == Index {
        for index in self.indices[indices.relative(to: self)] {
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
    public mutating func insert(_ symbol: Symbol, at  index: Index) {
        self._characters.insert(symbol.character, at: index.character)
        self._attributes.insert(symbol.attribute, at: index.attribute)
    }
        
    @inlinable @inline(__always)
    public mutating func insert(_ character: Character,
    at index: Index, as attribute: Attribute = .content) {
        self.insert(Symbol(character, as: attribute), at: index)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Insert x Collection
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func insert(contentsOf characters: some Collection<Character>,
    at index: Index, as attribute: Attribute = .content) {
        self.insert(contentsOf: characters, at: index, as: { _ in attribute })
    }
    
    @inlinable @inline(__always)
    public mutating func insert(contentsOf characters: some Collection<Character>,
    at index: Index, as attribute: (Character) -> Attribute) {
        self.replaceSubrange(index..<index, with: characters, as: attribute)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Remove
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) @discardableResult
    public mutating func remove(at index: Index) -> Symbol {
        Symbol(self._characters.remove(at: index.character),
        as:    self._attributes.remove(at: index.attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Replace
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func replaceSubrange(_ indices: Range<Index>,
    with symbols: some Collection<Symbol>) {
        self.replaceSubrange(indices,
        characters: symbols.lazy.map(\.character),
        attributes: symbols.lazy.map(\.attribute))
    }
    
    @inlinable @inline(__always)
    public mutating func replaceSubrange(_ indices: Range<Index>,
    with characters: some Collection<Character>, as attribute: Attribute = .content) {
        self.replaceSubrange(indices, with: characters, as: { _ in attribute })
    }
    
    @inlinable @inline(__always)
    public mutating func replaceSubrange(_ indices: Range<Index>,
    with characters: some Collection<Character>, as attribute: (Character) -> Attribute) {
        self.replaceSubrange(indices,
        characters: characters,
        attributes: characters.lazy.map(attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    mutating func replaceSubrange(_ indices: Range<Index>,
    characters: some Collection<Character>,
    attributes: some Collection<Attribute>) {
        self._characters.replaceSubrange(
        indices.lowerBound.character ..<
        indices.upperBound.character, with: characters)
        
        self._attributes.replaceSubrange(
        indices.lowerBound.attribute ..<
        indices.upperBound.attribute, with: attributes)
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
    func nonpassthrough(at index: Index) -> Bool {
        !attributes[index.attribute].contains(.passthrough)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(from index: Index, towards direction: Direction) ->  Index? {
        direction == .forwards ? peek(ahead: index) : peek(behind: index)
    }
    
    @inlinable @inline(__always)
    func peek(ahead index: Index) -> Index? {
        index != endIndex ? index  : nil
    }
    
    @inlinable @inline(__always)
    func peek(behind index: Index) -> Index? {
        index != startIndex ? self.index(before: index) : nil
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Caret
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Search
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
        if let peek = peek(from: index, towards: preference),
        nonpassthrough(at: peek) { return index }
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
        targeting: nonpassthrough) { return caret }
        //=--------------------------------------=
        // Search In Opposite Direction
        //=--------------------------------------=
        if let caret = caret(from: index,
        towards: direction.reversed(),
        jumping: Jump.to, // use Jump.to on each direction
        targeting: nonpassthrough) { return caret }
        //=--------------------------------------=
        // Use Default Index On Caret Not Found
        //=--------------------------------------=
        return self.defaultIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards, Backwards, To, Through
    //=------------------------------------------------------------------------=
    
    @inlinable func caret(from index: Index, towards direction: Direction,
    jumping distance: Jump, targeting target: Target) -> Index? {
        switch (direction, distance) {
        case (.forwards,  .to     ): return caret(from: index, forwardsTo:       target)
        case (.forwards,  .through): return caret(from: index, forwardsThrough:  target)
        case (.backwards, .to     ): return caret(from: index, backwardsTo:      target)
        case (.backwards, .through): return caret(from: index, backwardsThrough: target)
        }
    }
    
    @inlinable @inline(__always)
    func caret(from index: Index, forwardsTo target: Target) -> Index? {
        indices[index...].first(where: target)
    }
    
    @inlinable @inline(__always)
    func caret(from index: Index, forwardsThrough target: Target) -> Index? {
        caret(from: index, forwardsTo: target).map(self.index(after:))
    }
    
    @inlinable @inline(__always)
    func caret(from index: Index, backwardsTo target: Target) -> Index? {
        caret(from: index, backwardsThrough: target).map(self.index(after:))
    }
    
    @inlinable @inline(__always)
    func caret(from index: Index, backwardsThrough target: Target) -> Index? {
        indices[..<index].last(where: target)
    }
    
    //*========================================================================*
    // MARK: * Types(s)
    //*========================================================================*

    @usableFromInline enum Jump { case to, through }
    
    @usableFromInline typealias Target = (Index) -> Bool
}
