//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar BystrΓΆm Ericsson
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
/// |+|1|2|_|(|3|4|5|)|_|6|7|8|-|9|#|-|#|#|~
/// |x|o|o|x|x|o|o|o|x|x|o|o|o|x|o|x|x|x|x|~
/// ```
///
/// **Anchor**
///
/// Set the anchor index to select the caret represented by it. This can be
/// desirable on snapshots containing only formatting characters. A pattern
/// style may set the anchor at its first placeholder character, for example.
///
/// ```
///    β == anchor
/// |+|#|#|_|(|#|#|#|)|_|#|#|#|-|#|#|-|#|#|~
/// |x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|~
/// ```
///
/// **Attributes & Characters**
///
/// The number of attributes must equal the number of joint characters in the
/// snapshot. A failure to maintain this invariant may crash the application.
/// In most cases, it is a trivial constraint because the easiest way to make
/// a snapshot is to loop over each character in a composed character sequence.
///
/// ```
/// |πΈπͺ|   |πΊπΈ|    |πΈπͺ|πΊπΈ|~
/// |β| + |β| -> |β|β|~ (GOOD)
/// ```
///
/// ```
/// |πΈ|   |πͺ|   |πΊ|   |πΈ|    |πΈπͺ|πΊπΈ|~
/// |β| + |β| + |β| + |β| -> |β|β|β|β|~ (BAD)
/// ```
///
public struct Snapshot: BidirectionalCollection, CustomStringConvertible, Equatable,
ExpressibleByArrayLiteral, ExpressibleByStringLiteral, RangeReplaceableCollection {
    
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
    
    @inlinable public init() {
        self._characters = ""
        self._attributes = []
    }
    
    @inlinable public init(arrayLiteral  symbols: Symbol...) {
        self.init(symbols)
    }
    
    @inlinable public init(stringLiteral characters: String) {
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
    
    @inlinable public init(_ characters: String, as attribute: Attribute = .content) {
        self.init(characters, as: { _ in attribute })
    }
    
    @inlinable public init(_ characters: String, as attribute: (Character) -> Attribute) {
        self._characters = characters
        self._attributes = []
        
        for character in characters {
            self._attributes.append(attribute(character))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Sequence
    //=------------------------------------------------------------------------=
    
    @inlinable public init(
    _ characters: some Sequence<Character>,
    as attribute: Attribute = .content) {
        self.init(characters, as: { _ in attribute })
    }
    
    @inlinable public init(
    _ characters: some Sequence<Character>,
    as attribute: (Character) -> Attribute) {
        self.init(); self.append(contentsOf: characters, as: attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Index, Element
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Index {
        Index(_characters.startIndex,
        as:   _attributes.startIndex)
    }

    @inlinable public var endIndex: Index {
        Index(_characters.endIndex,
        as:   _attributes.endIndex)
    }
    
    @inlinable public subscript(position: Index) -> Symbol {
        Symbol(_characters[position.character],
        as:    _attributes[position.attribute])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: After, Before, Distance
    //=------------------------------------------------------------------------=
    
    @inlinable public func index(after position: Index) -> Index {
        Index(_characters.index(after: position.character),
        as:   _attributes.index(after: position.attribute))
    }
    
    @inlinable public func index(before position: Index) -> Index {
        Index(_characters.index(before: position.character),
        as:   _attributes.index(before: position.attribute))
    }
    
    @inlinable public func index(_ position: Index, offsetBy distance: Int) -> Index {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions
    //=------------------------------------------------------------------------=
    
    public var description: String {
        "\(Self.self)(\"\(_characters)\", \(_attributes))"
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func transform(
    attributes position: Index,
    with transform: (inout Attribute) -> Void) {
        transform(&self._attributes[position.attribute])
    }
    
    @inlinable public mutating func transform(
    attributes positions: some Sequence<Index>,
    with transform: (inout Attribute) -> Void) {
        for index in positions {
            transform(&self._attributes[index.attribute])
        }
    }
    
    @inlinable public mutating func transform(
    attributes positions: some RangeExpression<Index>,
    with transform: (inout Attribute) -> Void) {
        for index in indices[positions.relative(to:self)] {
            transform(&self._attributes[index.attribute])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Append
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func append(_ symbol: Symbol) {
        self._characters.append(symbol.character)
        self._attributes.append(symbol.attribute)
    }
    
    @inlinable public mutating func append(
    _ character: Character, as attribute: Attribute = .content) {
        self.append(Symbol(character, as: attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Append x Sequence
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func append(
    contentsOf characters: some Sequence<Character>,
    as attribute: Attribute = .content) {
        self.append(contentsOf: characters, as: { _ in attribute })
    }
    
    @inlinable public mutating func append(
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
    
    @inlinable public mutating func insert(
    _ symbol: Symbol, at position: Index) {
        self._characters.insert(symbol.character,at: position.character)
        self._attributes.insert(symbol.attribute,at: position.attribute)
    }
        
    @inlinable public mutating func insert(
    _ character: Character, at position: Index, as attribute: Attribute = .content) {
        self.insert(Symbol(character, as: attribute), at: position)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Insert x Collection
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func insert(
    contentsOf characters: some Collection<Character>,
    at position: Index, as attribute: Attribute = .content) {
        self.insert(contentsOf: characters, at: position, as: { _ in attribute })
    }
    
    @inlinable public mutating func insert(
    contentsOf characters: some Collection<Character>,
    at position: Index, as attribute: (Character) -> Attribute) {
        self.replaceSubrange(position..<position, with: characters, as: attribute)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Remove
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func remove(at position: Index) -> Symbol {
        Symbol(self._characters.remove(at: position.character),
        as:    self._attributes.remove(at: position.attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Replace
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func replaceSubrange(_ positions: Range<Index>,
    with symbols: some Collection<Symbol>) {
        self.replaceSubrange(positions,
        characters: symbols.lazy.map(\.character),
        attributes: symbols.lazy.map(\.attribute))
    }
    
    @inlinable public mutating func replaceSubrange(_ positions: Range<Index>,
    with characters: some Collection<Character>, as attribute: (Character) -> Attribute) {
        self.replaceSubrange(positions,
        characters: characters,
        attributes: characters.lazy.map(attribute))
    }
    
    @inlinable public mutating func replaceSubrange(_ positions: Range<Index>,
    with characters: some Collection<Character>, as attribute: Attribute = .content) {
        self.replaceSubrange(positions, with: characters, as: { _ in attribute })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func replaceSubrange(_ positions: Range<Index>,
    characters: some Collection<Character>, attributes: some Collection<Attribute>) {
        self._characters.replaceSubrange(
        positions.lowerBound.character  ..<
        positions.upperBound.character, with: characters)
        
        self._attributes.replaceSubrange(
        positions.lowerBound.attribute  ..<
        positions.upperBound.attribute, with: attributes)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Resolve
    //=------------------------------------------------------------------------=
    
    @inlinable func resolve(_ caret: Caret<Index>) -> Index {
        //=--------------------------------------=
        // Anchor
        //=--------------------------------------=
        if let anchor { return anchor }
        //=--------------------------------------=
        // Inspect Initial Index
        //=--------------------------------------=
        let positions = self.indices
        
        if let adjacent = positions.index(
        from: caret.position,
        towards: caret.affinity,
        jumping: caret.affinity == .forwards ? .to : .through,
        targeting: { _ in true }),
        nonpassthrough(adjacent) { return caret.position }
        //=--------------------------------------=
        // Search In Dominant Direction
        //=--------------------------------------=
        var direction = caret.momentum ?? caret.affinity

        if let index = positions.index(
        from: caret.position,
        towards: direction,
        jumping: direction == caret.affinity ? .to : .through,
        targeting: nonpassthrough) { return index }
        //=--------------------------------------=
        // Search In Opposite Direction
        //=--------------------------------------=
        direction = direction.reversed()
        
        if let index = positions.index(
        from: caret.position,
        towards: direction,
        jumping: Jump.to, // do use Jump.to here
        targeting: nonpassthrough) { return index }
        //=--------------------------------------=
        // Return Preference On Caret Not Found
        //=--------------------------------------=
        return caret.affinity == .backwards ? startIndex : endIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func nonpassthrough(_ position: Index) -> Bool {
        !attributes[position.attribute].contains(Attribute.passthrough)
    }
}
