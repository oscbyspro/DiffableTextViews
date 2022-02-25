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
    
    @usableFromInline var _anchorIndex: Index?
    @inlinable public var  anchorIndex: Index? { _anchorIndex }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init() {
        self._characters = ""
        self._attributes = []
    }
    
    @inlinable public init<S>(_ characters: S, as attribute: Attribute) where
    S: Sequence, S.Element == Character {
        self.init(); for character in characters {
            self._characters.append(character)
            self._attributes.append(attribute)
        }
    }
    
    @inlinable public init<S>(_ characters: S, as attribute: Attribute) where
    S: RandomAccessCollection, S.Element == Character {
        self._characters = String(characters)
        self._attributes = [Attribute](repeating: attribute, count: characters.count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
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
    
    @inlinable public func index(after position: Index) -> Index {
        Index(_characters.index(after: position.character),
              _attributes.index(after: position.attribute))
    }
    
    @inlinable public func index(before position: Index) -> Index {
        Index(_characters.index(before: position.character),
              _attributes.index(before: position.attribute))
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
