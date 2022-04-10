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
/// Set the anchor to unconditionally select the caret represented by its index. This is required
/// when the snapshot contains only formatting characters, and you want the user's caret to appear
/// at a specific location. As an example, a pattern text style with an empty value may anchor at the
/// index of the first placeholder character.
///
public struct Snapshot: BidirectionalCollection, RangeReplaceableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @usableFromInline var _characters: String
    @usableFromInline var _attributes: [Attribute]
    @usableFromInline var _anchor: Index?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init() {
        self._characters = ""
        self._attributes = []
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Characters As Attribute
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ characters: String, as attribute: Attribute) {
        self._characters = characters
        self._attributes = Array(repeating: attribute, count: characters.count)
    }
    
    @inlinable public init<C>(_ characters: C, as attribute: Attribute) where
    C: RandomAccessCollection, C.Element == Character {
        self._characters = String(characters)
        self._attributes = Array(repeating: attribute, count: characters.count)
    }
    
    @inlinable public init<S>(_ characters: S, as attribute: Attribute) where
    S: Sequence, S.Element == Character { self.init()
        for character in characters {
            self._characters.append(character)
            self._attributes.append(attribute)
        }
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
    
    //=------------------------------------------------------------------------=
    // MARK: Element
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: Index) -> Symbol {
        Symbol(character: _characters[index.character],
               attribute: _attributes[index.attribute])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Index {
        Index(_characters.startIndex,
              _attributes.startIndex)
    }

    @inlinable public var endIndex: Index {
        Index(_characters.endIndex,
              _attributes.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: After / Before
    //=------------------------------------------------------------------------=
    
    @inlinable public func index(after  index: Index) -> Index {
        Index(_characters .index(after: index.character),
              _attributes .index(after: index.attribute))
    }
    
    @inlinable public func index(before  index: Index) -> Index {
        Index(_characters .index(before: index.character),
              _attributes .index(before: index.attribute))
    }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*

    public struct Index: Comparable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let character: String.Index
        @usableFromInline let attribute: Int

        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        @inlinable init(_ character: String.Index, _ attribute: Int) {
            self.character = character
            self.attribute = attribute
        }

        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=
        
        @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.attribute == rhs.attribute
        }
        
        @inlinable public static func <  (lhs: Self, rhs: Self) -> Bool {
            lhs.attribute <  rhs.attribute
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Snapshot: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "\(Self.self)(\"\(_characters)\", \(_attributes))"
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Anchor
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func anchorAtEndIndex() {
        self._anchor = endIndex
    }
    
    @inlinable mutating func anchor(at index: Index?) {
        self._anchor = index
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(attributes index: Index,
    with transform: (inout Attribute) -> Void) {
        transform(&_attributes[index.attribute])
    }
    
    @inlinable mutating func update<S: Sequence>(attributes indices: S,
    with transform: (inout Attribute) -> Void) where S.Element == Index {
        for index in indices {
            transform(&_attributes[index.attribute])
        }
    }
    
    @inlinable mutating func update<R: RangeExpression>(attributes indices: R,
    with transform: (inout Attribute) -> Void) where R.Bound == Index {
        for index in self.indices[indices.relative(to: self)] {
            transform(&_attributes[index.attribute])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Replacements
    //=------------------------------------------------------------------------=

    @inlinable mutating func replaceSubrange<C: Collection>(
    _ indices: Range<Index>, with elements: C) where C.Element == Symbol {
        _characters.replaceSubrange(
        indices.lowerBound.character ..<
        indices.upperBound.character,
        with: elements.lazy.map(\.character))
        _attributes.replaceSubrange(
        indices.lowerBound.attribute ..<
        indices.upperBound.attribute,
        with: elements.lazy.map(\.attribute))
    }
    
    @inlinable mutating func append(_ element: Symbol) {
        _characters.append(element.character)
        _attributes.append(element.attribute)
    }
    
    @inlinable mutating func append<S: Sequence>(
    contentsOf elements: S) where S.Element == Symbol {
        _characters.append(contentsOf: elements.lazy.map(\.character))
        _attributes.append(contentsOf: elements.lazy.map(\.attribute))
    }
    
    @inlinable mutating func insert(_ element: Element, at index: Index) {
        _characters.insert(element.character, at: index.character)
        _attributes.insert(element.attribute, at: index.attribute)
    }
    
    @inlinable mutating func insert<C: Collection>(
    contentsOf elements: C, at index: Index) where C.Element == Symbol {
        _characters.insert(contentsOf: elements.lazy.map(\.character), at: index.character)
        _attributes.insert(contentsOf: elements.lazy.map(\.attribute), at: index.attribute)
    }
    
    @inlinable @discardableResult mutating func remove(at index: Index) -> Symbol {
        Symbol(character: _characters.remove(at: index.character),
               attribute: _attributes.remove(at: index.attribute))
    }
}
