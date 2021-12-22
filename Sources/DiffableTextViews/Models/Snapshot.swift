//
//  Snapshot.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

import protocol Utilities.Transformable

// MARK: - Snapshot

public struct Snapshot: BidirectionalCollection, RangeReplaceableCollection, ExpressibleByArrayLiteral, Transformable {
    public typealias Element = Symbol
    public typealias Indices = DefaultIndices<Self>
    public typealias Characters = String
    public typealias Attributes = Array<Attribute>
    
    // MARK: Properties

    @usableFromInline var _characters: Characters
    @usableFromInline var _attributes: Attributes

    // MARK: Properties: Get
    
    @inlinable @inline(__always) public var characters: Characters { _characters }
    @inlinable @inline(__always) public var attributes: Attributes { _attributes }

    // MARK: Initialization

    @inlinable public init() {
        self._characters = ""
        self._attributes = []
    }
    
    @inlinable public init(_ characters: String, only attribute: Attribute) {
        self._characters = characters
        self._attributes = Attributes(repeating: attribute, count: characters.count)
    }
        
    @inlinable public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
    // MARK: Collection: Counts
    
    /// - Complexity: O(1).
    @inlinable @inline(__always) public var count: Int {
        _attributes.count
    }
    
    /// - Complexity: O(1).
    @inlinable @inline(__always) public var underestimatedCount: Int {
        _attributes.underestimatedCount
    }
    
    // MARK: Collection: Indices

    @inlinable public var startIndex: Index {
        Index(character: _characters.startIndex, attribute: _attributes.startIndex)
    }

    @inlinable public var endIndex: Index {
        Index(character: _characters.endIndex, attribute: _attributes.endIndex)
    }
    
    // MARK: Collection: Traversals
    
    @inlinable public func index(after i: Index) -> Index {
        Index(character: _characters.index(after:  i.character), attribute: _attributes.index(after: i.attribute))
    }
    
    @inlinable public func index(before i: Index) -> Index {
        Index(character: _characters.index(before: i.character), attribute: _attributes.index(before: i.attribute))
    }
    
    // MARK: Collection: Transformations
        
    @inlinable public mutating func append(_ element: Element) {
        _characters.append(element.character)
        _attributes.append(element.attribute)
    }
    
    @inlinable public mutating func insert(_ element: Element, at index: Index) {
        _characters.insert(element.character, at: index.character)
        _attributes.insert(element.attribute, at: index.attribute)
    }

    @inlinable public mutating func replaceSubrange<C: Collection>(_ range: Range<Index>, with elements: C) where C.Element == Element {
        _characters.replaceSubrange(range.lowerBound.character ..< range.upperBound.character, with: elements.lazy.map(\.character))
        _attributes.replaceSubrange(range.lowerBound.attribute ..< range.upperBound.attribute, with: elements.lazy.map(\.attribute))
    }
        
    // MARK: Collection: Subscripts
    
    @inlinable public subscript(position: Index) -> Element {
        .init(_characters[position.character], attribute: _attributes[position.attribute])
    }
    
    @inlinable public subscript(character position: Index) -> Character {
        _read { yield _characters[position.character] }
    }
    
    @inlinable public subscript(attribute position: Index) -> Attribute {
        _read   { yield  _attributes[position.attribute] }
        _modify { yield &_attributes[position.attribute] }
    }
    
    // MARK: Collection: Index

    public struct Index: Comparable {
        @usableFromInline let character: String.Index
        @usableFromInline let attribute: Int

        // MARK: Initializers

        @inlinable init(character: String.Index, attribute: Int) {
            self.character = character
            self.attribute = attribute
        }

        // MARK: Utilities

        @inlinable @inline(__always) var offset: Int {
            attribute
        }

        // MARK: Comparable

        @inlinable @inline(__always) public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.offset < rhs.offset
        }
    }
}

// MARK: - Transformations

public extension Snapshot {
    
    // MARK: Attributes
    
    @inlinable mutating func transform(attributes index: Index, using transformation: (Attribute) -> Attribute) {
        _attributes[index.attribute] = transformation(_attributes[index.attribute])
    }
    
    @inlinable mutating func transform(attributes index: Index, using transformation: (inout Attribute) -> Void) {
        transformation(&_attributes[index.attribute])
    }
    
    @inlinable mutating func transform<R: RangeExpression>(attributes expression: R, using transformation: (Attribute) -> Attribute) where R.Bound == Index {
        let indices = interpret(expression, map: \.attribute); _attributes.replaceSubrange(indices, with: _attributes[indices].map(transformation))
    }
        
    @inlinable mutating func transform<R: RangeExpression>(attributes expression: R, using transformation: (inout Attribute) -> Void) where R.Bound == Index {
        for index in interpret(expression, map: \.attribute) { transformation(&_attributes[index]) }
    }
    
    // MARK: Attributes: Helpers

    @inlinable internal func interpret<R: RangeExpression, Bound>(_ indices: R, map: (Index) -> Bound) -> Range<Bound> where R.Bound == Index {
        let indices = indices.relative(to: self); return map(indices.lowerBound) ..< map(indices.upperBound)
    }
    
    // MARK: Characters
    
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable func characters(where predicate: (Element) -> Bool) -> String {
        reduce(into: String()) { result, element in
            if predicate(element) {
                result.append(element.character)
            }
        }
    }
}
