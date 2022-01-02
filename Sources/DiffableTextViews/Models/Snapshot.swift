//
//  Snapshot.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

//*============================================================================*
// MARK: * Snapshot
//*============================================================================*

public struct Snapshot: BidirectionalCollection, RangeReplaceableCollection {
    public typealias Element = Symbol
    public typealias Indices = DefaultIndices<Self>
    public typealias Characters = String
    public typealias Attributes = Array<Attribute>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline var _characters: Characters
    @usableFromInline var _attributes: Attributes

    //
    // MARK: Properties - Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var characters: Characters { _characters }
    @inlinable public var attributes: Attributes { _attributes }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init() {
        self._characters = ""
        self._attributes = []
    }
    
    @inlinable public init(_ characters: String, only attribute: Attribute) {
        self._characters = characters
        self._attributes = Attributes(repeating: attribute, count: characters.count)
    }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*

    public struct Index: Comparable {
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
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
        
        @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.attribute < rhs.attribute
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Snapshot - BidirectionalCollection
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
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
    // MARK: Range
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        Index(character: _characters.startIndex, attribute: _attributes.startIndex)
    }

    @inlinable var endIndex: Index {
        Index(character: _characters.endIndex, attribute: _attributes.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traversal
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after i: Index) -> Index {
        Index(character: _characters.index(after:  i.character), attribute: _attributes.index(after: i.attribute))
    }
    
    @inlinable func index(before i: Index) -> Index {
        Index(character: _characters.index(before: i.character), attribute: _attributes.index(before: i.attribute))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Access
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Element {
        .init(_characters[position.character], attribute: _attributes[position.attribute])
    }
    
    //
    // MARK: Access - Components
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character position: Index) -> Character {
        _read   { yield  _characters[position.character] }
    }
    
    @inlinable subscript(attribute position: Index) -> Attribute {
        _read   { yield  _attributes[position.attribute] }
        _modify { yield &_attributes[position.attribute] }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Sbapshot - RangeReplaceableCollection
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Replace
    //=------------------------------------------------------------------------=

    @inlinable mutating func replaceSubrange<C: Collection>(_ range: Range<Index>, with elements: C) where C.Element == Element {
        _characters.replaceSubrange(range.lowerBound.character ..< range.upperBound.character, with: elements.lazy.map(\.character))
        _attributes.replaceSubrange(range.lowerBound.attribute ..< range.upperBound.attribute, with: elements.lazy.map(\.attribute))
    }
    
    //
    // MARK: Replace - Optimizations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ element: Element) {
        _characters.append(element.character)
        _attributes.append(element.attribute)
    }

    @inlinable mutating func insert(_ element: Element, at index: Index) {
        _characters.insert(element.character, at: index.character)
        _attributes.insert(element.attribute, at: index.attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Snapshot - Transformations
//=----------------------------------------------------------------------------=

public extension Snapshot {

    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    #warning("Short divs.")
    @inlinable mutating func transform(
        attributes index: Index,
        with transformation: (inout Attribute) -> Void) {
        //=----------------------------=
        transformation(&_attributes[index.attribute])
    }
    
    @inlinable mutating func transform<S: Sequence>(
        attributes sequence: S,
        with transformation: (inout Attribute) -> Void)
        where S.Element == Index {
        //=----------------------------=
        for index in sequence {
            transform(attributes: index, with: transformation)
        }
    }
        
    @inlinable mutating func transform<R: RangeExpression>(
        attributes range: R,
        with transformation: (inout Attribute) -> Void)
        where R.Bound == Index {
        //=----------------------------=
        transform(attributes: indices[range.relative(to: self)], with: transformation)
    }
}
