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

    public typealias Characters = String
    public typealias Attributes = Array<Attribute>
    
    // MARK: Properties

    @usableFromInline var _characters: Characters
    @usableFromInline var _attributes: Attributes
        
    // MARK: Getters
    
    @inlinable public var characters: Characters { _characters }
    @inlinable public var attributes: Attributes { _attributes }

    // MARK: Initialization

    public init() {
        self._characters = ""
        self._attributes = []
    }
    
    public init(_ characters: String, only attribute: Attribute) {
        self._characters = characters
        self._attributes = Attributes(repeating: attribute, count: characters.count)
    }
        
    @inlinable public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
    // MARK: Utilities
    
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable public func content() -> String {
        reduce(map: \.character, where: \.content)
    }
    
    // MARK: Collection: Counts
    
    /// - Complexity: O(1).
    @inlinable public var count: Int {
        attributes.count
    }
    
    /// - Complexity: O(1).
    @inlinable public var underestimatedCount: Int {
        attributes.underestimatedCount
    }
    
    // MARK: Collection: Indices

    @inlinable public var startIndex: Index {
        Index(characters.startIndex, attributes.startIndex)
    }

    @inlinable public var endIndex: Index {
        Index(characters.endIndex,   attributes.endIndex)
    }
    
    // MARK: Collection: Traversals
    
    @inlinable public func index(after i: Index) -> Index {
        Index(characters.index(after:  i.character), attributes.index(after: i.attribute))
    }
    
    @inlinable public func index(before i: Index) -> Index {
        Index(characters.index(before: i.character), attributes.index(before: i.attribute))
    }
    
    // MARK: Collection: Replacements
        
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
        _read {
            yield Element(characters[position.character], attribute: attributes[position.attribute])
        }
    }
    
    // MARK: Collection: Index

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
    
    // MARK: Weird
    
    /// Appends: Symbol.suffix(Character.null).
    ///
    /// Improves performance under some circumstances.
    ///
    /// ```
    /// let reason = "¯\_(ツ)_/¯"
    /// ```
    ///
    /// - NumericTextStyle's CPU usage doubles when it applies a suffix, unless this method is called.
    ///
    /// - Note: Should be called at most once, after all other changes have been made to this Snapshot.
    ///
    /// - Complexity: O(1) on average.
    @inlinable public mutating func complete() {
        append(.suffix("\0"))
    }
}
