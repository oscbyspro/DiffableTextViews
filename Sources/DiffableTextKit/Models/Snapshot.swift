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

/// A collection of characters and attributes.
///
/// Attributes describe how characters should be treated. As an example:
/// virtual characters should not be parsed, and passthrough characters should
/// not be selected. A single character can have multiple attributes.
///
/// ```
/// │+│1│2│_│(│3│4│5│)│_│6│7│8│-│9│#│-│#│#│
/// │x│o│o│x│x│o│o│o│x│x│o│o│o│x│o│x│x│x│x│
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
/// │🇸🇪│   │🇺🇸│    │🇸🇪│🇺🇸│
/// │➖│ + │➖│ -> │➖│➖│ (GOOD)
/// ```
///
/// ```
/// │🇸│   │🇪│   │🇺│   │🇸│    │🇸🇪│🇺🇸│
/// │➖│ + │➖│ + │➖│ + │➖│ -> │➖│➖│➖│➖│ (BAD)
/// ```
///
public struct Snapshot: BidirectionalCollection, CustomStringConvertible, Equatable,
ExpressibleByArrayLiteral, ExpressibleByStringLiteral, RangeReplaceableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @usableFromInline private(set) var _characters: String
    @usableFromInline private(set) var _attributes: [Attribute]
    
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
    
    @inlinable @inline(__always) public var characters: String {
        _characters
    }
    
    @inlinable @inline(__always) public var attributes: [Attribute] {
        _attributes
    }
    
    public var description: String {
        "\(Self.self)(\"\(_characters)\", \(_attributes))"
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
    
    @inlinable public init(_ characters: some Sequence<Character>, as attribute: Attribute = .content) {
        self.init(characters, as: { _ in attribute })
    }
    
    @inlinable public init(_ characters: some Sequence<Character>, as attribute: (Character) -> Attribute) {
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
    // MARK: After, Before
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
    
    @inlinable public func index(_ position: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        guard let attribute = _attributes.index(position.attribute/*----*/,
        offsetBy: distance, limitedBy: limit.attribute) else { return nil }
        guard let character = _characters.index(position.character/*----*/,
        offsetBy: distance, limitedBy: limit.character) else { return nil }
        return Index(character, as: attribute)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Distance, Count
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Index, to end: Index) -> Int {
        _attributes.distance(from: start.attribute,to: end.attribute)
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
        for position in positions {
            transform(&self._attributes[position.attribute])
        }
    }
    
    @inlinable public mutating func transform(
    attributes positions: some RangeExpression<Index>,
    with transform: (inout Attribute) -> Void) {
        for position in indices[positions.relative(to:self)] {
            transform(&self._attributes[position.attribute])
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
    
    @inlinable public mutating func insert(_ symbol: Symbol, at position: Index) {
        self._characters.insert(symbol.character, at: position.character)
        self._attributes.insert(symbol.attribute, at: position.attribute)
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
    // MARK: Replace x Private
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
    // MARK: Searches
    //=------------------------------------------------------------------------=
    
    @inlinable public func range(of text: some StringProtocol, first direction: Direction) -> Range<Index>? {
        characters.range(of: text, options: (direction == .forwards) ? [] : [.backwards]).map(range)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
    
    @inlinable public func range(at positions: Range<String.Index>) -> Range<Index> {
        let lower = index(at: positions.lowerBound, from: startIndex)
        let upper = index(at: positions.upperBound, from: lower/*-*/)
        return Range(uncheckedBounds:(lower,upper))
    }
    
    @inlinable public func index(at position: String.Index) -> Index {
        index(at: position, from: startIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions x Internal
    //=------------------------------------------------------------------------=
    
    @inlinable func index(at position: String.Index, from start: Index) -> Index {
        var character = position; if character != characters.endIndex {
            character = characters.rangeOfComposedCharacterSequence(at: character).lowerBound
        }
        
        let stride = characters.distance(from: start.character, to: character)
        return Index(character, as: attributes.index(start.attribute, offsetBy: stride))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Internal
//=----------------------------------------------------------------------------=

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Resolve
    //=------------------------------------------------------------------------=
    
    @inlinable func resolve(_ caret: Caret<Index>) -> Index {
        //=--------------------------------------=
        // Inspect Initial Index
        //=--------------------------------------=
        let indices = self.indices
        
        if let adjacent = indices.index(
        from: caret.position,
        towards: caret.affinity,
        jumping: caret.affinity == .forwards ? .to : .through,
        targeting: { _ in true }),
        nonpassthrough(adjacent) { return caret.position }
        //=--------------------------------------=
        // Search In Dominant Direction
        //=--------------------------------------=
        var direction = caret.momentum ?? caret.affinity

        if let index = indices.index(
        from: caret.position,
        towards: direction,
        jumping: direction == caret.affinity ? .to : .through,
        targeting: nonpassthrough) { return index }
        //=--------------------------------------=
        // Search In Opposite Direction
        //=--------------------------------------=
        direction = direction.reversed()
        
        if let index = indices.index(
        from: caret.position,
        towards: direction,
        jumping: Jump.to, // direction independent
        targeting: nonpassthrough) { return index }
        //=--------------------------------------=
        // Return Preference On Caret Not Found
        //=--------------------------------------=
        return caret.affinity == .backwards ? startIndex : endIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Resolve x Private
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func nonpassthrough(_ position: Index) -> Bool {
        !attributes[position.attribute].contains(Attribute.passthrough)
    }
}
