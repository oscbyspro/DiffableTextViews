//
//  Snapshot.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

import struct Collections.Insights

public struct Layout: BidirectionalCollection, RangeReplaceableCollection, ExpressibleByArrayLiteral {
    public typealias Element = Symbol
    public typealias Indices = DefaultIndices<Self>
    public typealias SubSequence = Slice<Self>

    // MARK: Storage

    public private(set) var characters: String
    public private(set) var attributes: [Attribute]

    // MARK: Initialization

    public init() {
        self.characters = ""
        self.attributes = []
    }
    
    public init(_ characters: String, only attribute: Attribute) {
        self.attributes = characters.map({ _ in attribute })
        self.characters = characters
    }
        
    @inlinable public init(arrayLiteral elements: Symbol...) {
        self.init(elements)
    }
    
    // MARK: Utilities
    
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable public func content() -> String {
        reduce(map: \.character, where: \.content)
    }
    
    // MARK: Index

    @inlinable public var startIndex: Index {
        Index(characters.startIndex, attributes.startIndex)
    }

    @inlinable public var endIndex: Index {
        Index(characters.endIndex, attributes.endIndex)
    }
    
    // MARK: Traversal
    
    @inlinable public func index(after i: Index) -> Index {
        Index(characters.index(after: i.character), attributes.index(after: i.attribute))
    }
    
    @inlinable public func index(before i: Index) -> Index {
        Index(characters.index(before: i.character), attributes.index(before: i.attribute))
    }
    
    // MARK: Replacements

    public mutating func replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newElements: C) where C.Element == Symbol {
        attributes.replaceSubrange(subrange.map(bounds: \.attribute), with: newElements.view(\.attribute))
        characters.replaceSubrange(subrange.map(bounds: \.character), with: newElements.view(\.character))
    }
    
    // MARK: Subscripts
    
    @inlinable public subscript(position: Index) -> Symbol {
        _read {
            yield Symbol(characters[position.character], attribute: attributes[position.attribute])
        }
    }
    
    // MARK: Optimization
    
    /// - Complexity: O(1).
    @inlinable public var count: Int {
        attributes.count
    }
    
    /// - Complexity: O(1).
    @inlinable public var underestimatedCount: Int {
        attributes.underestimatedCount
    }

    // MARK: Components

    public struct Index: Comparable {
        @usableFromInline let character: String.Index
        @usableFromInline let attribute: Int

        // MARK: Initializers

        @inlinable init(_ character: String.Index, _ attribute: Int) {
            self.character = character
            self.attribute = attribute
        }

        // MARK: Utilities

        @inlinable var offset: Int {
            attribute
        }

        // MARK: Comparable

        @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.offset < rhs.offset
        }
    }
}
