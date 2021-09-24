//
//  Symbols.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public struct Symbols: BidirectionalCollection, RangeReplaceableCollection {
    public typealias SubSequence = Slice<Self>
    
    // MARK: Properties
    
    @usableFromInline var characters: String
    @usableFromInline var attributes: [Attribute]

    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable public init() {
        self.characters = ""
        self.attributes = []
    }
    
    // MARK: BidirectionalCollection
    
    /// - Complexity: O(1).
    @inlinable public var startIndex: Index {
        Index(characters.startIndex, attributes.startIndex)
    }
    
    /// - Complexity: O(1).
    @inlinable public var endIndex: Index {
        Index(characters.endIndex, attributes.endIndex)
    }
    
    /// - Complexity: O(1).
    @inlinable public func index(after i: Index) -> Index {
        Index(characters.index(after: i.character), attributes.index(after: i.attribute))
    }
    
    /// - Complexity: O(1).
    @inlinable public func index(before i: Index) -> Index {
        Index(characters.index(before: i.character), attributes.index(before: i.attribute))
    }
    
    /// - Complexity: O(1).
    @inlinable public subscript(position: Index) -> Symbol {
        _read {
            yield Symbol(characters[position.character], attribute: attributes[position.attribute])
        }
    }
    
    // MARK: RangeReplacableCollection
    
    /// - Complexity: O(n + m) where n is length of this collection and m is the length of newElements.
    @inlinable public mutating func replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newElements: C) where C.Element == Symbol {
        characters.replaceSubrange(subrange.lowerBound.character ..< subrange.upperBound.character, with: newElements.map(\.character))
        attributes.replaceSubrange(subrange.lowerBound.attribute ..< subrange.upperBound.attribute, with: newElements.map(\.attribute))
    }

    // MARK: Components
    
    public struct Index: Comparable {
        @usableFromInline let character: String.Index
        @usableFromInline let attribute: Int
        
        /// - Complexity: O(1).
        @inlinable init(_ character: String.Index, _ attribute: Int) {
            self.character = character
            self.attribute = attribute
        }
        
        /// - Complexity: O(1).
        @inlinable var offset: Int {
            attribute
        }
        
        /// - Complexity: O(1).
        @inlinable public static func < (lhs: Symbols.Index, rhs: Symbols.Index) -> Bool {
            lhs.offset < rhs.offset
        }
    }
}

// MARK: - Carets

extension Symbols {
    @inlinable var carets: Carets {
        Carets(self)
    }
}

extension Symbols.SubSequence {
    @inlinable var carets: Carets {
        Carets(self)
    }
}
