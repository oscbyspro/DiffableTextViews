//
//  Snapshot.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public struct Snapshot: BidirectionalCollection, RangeReplaceableCollection, ExpressibleByArrayLiteral {
    public typealias Element = Symbol
    public typealias Indices = DefaultIndices<Self>
    public typealias SubSequence = Slice<Self>

    // MARK: Storage

    public var characters: String
    public var attributes: [Attribute]

    // MARK: Initialization

    @inlinable public init() {
        self.characters = ""
        self.attributes = []
    }
    
    @inlinable public init(_ characters: String, only attribute: Attribute) {
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

    @inlinable public mutating func replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newElements: C) where C.Element == Symbol {
        attributes.replaceSubrange(subrange.map(bounds: \.attribute), with: newElements.lazy.map(\.attribute))
        characters.replaceSubrange(subrange.map(bounds: \.character), with: newElements.lazy.map(\.character))
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

// MARK: Optimizations

extension Snapshot {
    
    // MARK: Complete
    
    /// Appends: Symbol.suffix(Character.null).
    ///
    /// Improves performance in certain circumstances.
    ///
    /// - Example: NumericTextStyle's CPU usage increases +3x when suffix is used, unless this method is called.
    ///
    /// - Note: Should be called at most once, after all other changes have been made to this Snapshot.
    ///
    @inlinable public mutating func complete() {
        append(Symbol.suffix("\0"))
    }
}
