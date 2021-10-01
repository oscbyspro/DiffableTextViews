//
//  Snapshot.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public struct Snapshot: BidirectionalCollection, RangeReplaceableCollection {
    public typealias Element = Symbol
    public typealias Indices = DefaultIndices<Self>
    public typealias SubSequence = Slice<Self>

    // MARK: Storage

    @usableFromInline var characters: String
    @usableFromInline var attributes: [Symbol.Attribute]

    // MARK: Initializers

    @inlinable public init() {
        self.characters = ""
        self.attributes = []
    }

    // MARK: Utilities

    @inlinable func content() -> String {
        reduce(into: String(), map: \.character, where: \.content)
    }

    // MARK: Index

    @inlinable public var startIndex: Index {
        Index(characters.startIndex, attributes.startIndex)
    }

    @inlinable public var endIndex: Index {
        Index(characters.endIndex, attributes.endIndex)
    }
    
    // MARK: Traverse

    @inlinable public func index(after i: Index) -> Index {
        Index(characters.index(after: i.character), attributes.index(after: i.attribute))
    }

    @inlinable public func index(before i: Index) -> Index {
        Index(characters.index(before: i.character), attributes.index(before: i.attribute))
    }

    // MARK: Replace

    @inlinable public mutating func replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newElements: C) where C.Element == Symbol {
        characters.replaceSubrange(subrange.transform(bounds: \.character), with: newElements.view(\.character))
        attributes.replaceSubrange(subrange.transform(bounds: \.attribute), with: newElements.view(\.attribute))
    }
    
    // MARK: Subscripts
    
    @inlinable public subscript(position: Index) -> Symbol {
        _read {
            yield Symbol(characters[position.character], attribute: attributes[position.attribute])
        }
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

