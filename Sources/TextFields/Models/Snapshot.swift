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

    public var attributes: [Attribute]
    public var characters: String
    public var content: String

    // MARK: Initialization

    @inlinable public init() {
        self.attributes = []
        self.characters = ""
        self.content = ""
    }
    
    @inlinable public init(content: String) {
        self.attributes = content.map({ _ in .content })
        self.characters = content
        self.content = content
    }
        
    @inlinable public init(arrayLiteral elements: Symbol...) {
        self.init(elements)
    }
        
    // MARK: Index

    @inlinable public var startIndex: Index {
        Index(attributes.startIndex, characters.startIndex, content.startIndex)
    }

    @inlinable public var endIndex: Index {
        Index(attributes.endIndex, characters.endIndex, content.endIndex)
    }
    
    // MARK: Traverse
    
    @inlinable public func index(after i: Index) -> Index {
        step(i, attributes.index(after:), characters.index(after:), contentIndex(after:peak:))
    }
    
    @inlinable public func index(before i: Index) -> Index {
        step(i, attributes.index(before:), characters.index(before:), contentIndex(before:peak:))
    }
    
    // MARK: Traverse: Helpers
    
    @inlinable func step(_ index: Index, _ attributes: (Int) -> Int, _ characters: (String.Index) -> String.Index, _ content: (String.Index, Int) -> String.Index) -> Index {
        let attributesIndex = attributes(index.attribute)
        let charactersIndex = characters(index.character)
        let contentIndex = content(index.content, attributesIndex)
        
        return Index(attributesIndex, charactersIndex, contentIndex)
    }
    
    @inlinable func contentIndex(after contentIndex: String.Index, peak: Int) -> String.Index {
        guard peak < attributes.endIndex else { return content.endIndex }
        return attributes[peak] == .content ? content.index(after: contentIndex) : contentIndex
    }
    
    @inlinable func contentIndex(before contentIndex: String.Index, peak: Int) -> String.Index {
        guard peak > attributes.startIndex else { return content.startIndex }
        return attributes[peak] == .content ? content.index(before: contentIndex) : contentIndex
    }
    
    // MARK: Replace

    @inlinable public mutating func replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newElements: C) where C.Element == Symbol {
        attributes.replaceSubrange(subrange.map(bounds: \.attribute), with: newElements.view(\.attribute))
        characters.replaceSubrange(subrange.map(bounds: \.character), with: newElements.view(\.character))
        content.replaceSubrange(subrange.map(bounds: \.content), with: newElements.compactView(content(in:)))
    }
    
    // MARK: Replace: Helpers
    
    @inlinable func content(in symbol: Symbol) -> Character? {
        symbol.attribute == .content ? symbol.character : nil
    }
    
    // MARK: Subscripts
    
    @inlinable public subscript(position: Index) -> Symbol {
        _read {
            yield Symbol(characters[position.character], attribute: attributes[position.attribute])
        }
    }
    
    // MARK: Optimizations
    
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
        @usableFromInline let attribute: Int
        @usableFromInline let character: String.Index
        @usableFromInline let content: String.Index

        // MARK: Initializers

        @inlinable init(_ attribute: Int, _ character: String.Index, _ content: String.Index) {
            self.attribute = attribute
            self.character = character
            self.content = content
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
