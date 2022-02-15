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
public struct Snapshot: BidirectionalCollection, RangeReplaceableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline var _characters: String
    @inlinable public var  characters: String { _characters }

    @usableFromInline var _attributes: [Attribute]
    @inlinable public var  attributes: [Attribute] { _attributes }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init() {
        self._characters = ""
        self._attributes = []
    }
    
    @inlinable public init<S: Sequence>(_ sequence: S, as attribute: Attribute) where S.Element == Character {
        self._characters = String(sequence)
        self._attributes = [Attribute](repeating: attribute, count: _characters.count)
    }
    
    @inlinable public init<C: Collection>(_ collection: C, as attribute: Attribute) where C.Element == Character {
        self._characters = String(collection)
        self._attributes = [Attribute](repeating: attribute, count: collection.count)
    }
    
    @inlinable public init(_ characters: String, as attribute: Attribute) {
        self._characters = characters
        self._attributes = [Attribute](repeating: attribute, count: characters.count)
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

        @inlinable internal init(character: String.Index, attribute: Int) {
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
// MARK: + BidirectionalCollection
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Symbol {
        Symbol(_characters[position.character], as: _attributes[position.attribute])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Count is O(1)
    //=------------------------------------------------------------------------=
    
    /// - Complexity: O(1).
    @inlinable var count: Int {
        _attributes.count
    }
    
    /// - Complexity: O(1).
    @inlinable var underestimatedCount: Int {
        _attributes.underestimatedCount
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        Index(character: _characters.startIndex,
              attribute: _attributes.startIndex)
    }

    @inlinable var endIndex: Index {
        Index(character: _characters.endIndex,
              attribute: _attributes.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traversal
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after position: Index) -> Index {
        Index(character: _characters.index(after: position.character),
              attribute: _attributes.index(after: position.attribute))
    }
    
    @inlinable func index(before position: Index) -> Index {
        Index(character: _characters.index(before: position.character),
              attribute: _attributes.index(before: position.attribute))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + RangeReplaceableCollection
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Replace
    //=------------------------------------------------------------------------=

    @inlinable mutating func replaceSubrange<C>(_ range: Range<Index>,
        with elements: C) where C: Collection, C.Element == Symbol {
        _characters.replaceSubrange(
            range.lowerBound.character ..< range.upperBound.character,
            with: elements.lazy.map(\.character))
        _attributes.replaceSubrange(
            range.lowerBound.attribute ..< range.upperBound.attribute,
            with: elements.lazy.map(\.attribute))
    }
    
    @inlinable mutating func append(_ element: Symbol) {
        _characters.append(element.character)
        _attributes.append(element.attribute)
    }
    
    @inlinable mutating func insert(_ element: Element, at position: Index) {
        _characters.insert(element.character, at: position.character)
        _attributes.insert(element.attribute, at: position.attribute)
    }
    
    @discardableResult @inlinable mutating func remove(at position: Index) -> Symbol {
        Symbol(_characters.remove(at: position.character), as: _attributes.remove(at: position.attribute))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Attributes
//=----------------------------------------------------------------------------=

public extension Snapshot {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(attributes position: Index,
        with transform: (inout Attribute) -> Void) {
        transform(&_attributes[position.attribute])
    }
    
    @inlinable mutating func update<S: Sequence>(attributes sequence: S,
        with transform: (inout Attribute) -> Void) where S.Element == Index {
        for position in sequence { transform(&_attributes[position.attribute]) }
    }
    
    @inlinable mutating func update<R: RangeExpression>(attributes range: R,
        with transform: (inout Attribute) -> Void) where R.Bound == Index {
        for position in indices[range.relative(to: self)] { transform(&_attributes[position.attribute]) }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Snapshot: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "\(Self.self)(\"\(_characters)\", \(_attributes))"
    }
}
