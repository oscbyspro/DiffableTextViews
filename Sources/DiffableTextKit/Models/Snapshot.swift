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
    
    @inlinable public subscript(position: Index) -> Symbol {
        Symbol(character: _characters[position.character],
               attribute: _attributes[position.attribute])
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
    
    @inlinable public func index(after  position: Index) -> Index {
        Index(_characters .index(after: position.character),
              _attributes .index(after: position.attribute))
    }
    
    @inlinable public func index(before  position: Index) -> Index {
        Index(_characters .index(before: position.character),
              _attributes .index(before: position.attribute))
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
    
    @inlinable mutating func anchor(at position: Index?) {
        self._anchor = position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(attributes position: Index,
    with transform: (inout Attribute) -> Void) {
        transform(&_attributes[position.attribute])
    }
    
    @inlinable mutating func update<S: Sequence>(attributes sequence: S,
    with transform: (inout Attribute) -> Void) where S.Element == Index {
        for position in sequence {
            transform(&_attributes[position.attribute])
        }
    }
    
    @inlinable mutating func update<R: RangeExpression>(attributes range: R,
    with transform: (inout Attribute) -> Void) where R.Bound == Index {
        for position in indices[range.relative(to: self)] {
            transform(&_attributes[position.attribute])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Replacements
    //=------------------------------------------------------------------------=

    @inlinable mutating func replaceSubrange<C: Collection>(
    _ range: Range<Index>, with elements: C) where C.Element == Symbol {
        _characters.replaceSubrange(
        range.lowerBound.character ..<
        range.upperBound.character,
        with: elements.lazy.map(\.character))
        _attributes.replaceSubrange(
        range.lowerBound.attribute ..<
        range.upperBound.attribute,
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
    
    @inlinable mutating func insert(_ element: Element, at position: Index) {
        _characters.insert(element.character, at: position.character)
        _attributes.insert(element.attribute, at: position.attribute)
    }
    
    @inlinable mutating func insert<C: Collection>(
    contentsOf elements: C, at position: Index) where C.Element == Symbol {
        _characters.insert(contentsOf: elements.lazy.map(\.character), at: position.character)
        _attributes.insert(contentsOf: elements.lazy.map(\.attribute), at: position.attribute)
    }
    
    @inlinable @discardableResult mutating func remove(at position: Index) -> Symbol {
        Symbol(character: _characters.remove(at: position.character),
               attribute: _attributes.remove(at: position.attribute))
    }
}
