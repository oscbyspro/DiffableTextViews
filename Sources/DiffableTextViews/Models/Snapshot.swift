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
    
    @inlinable public init<S>(_ elements: S, as attribute: Attribute) where
    S: Sequence, S.Element == Character {
        self.init(); for character in elements {
            self._characters.append(character)
            self._attributes.append(attribute)
        }
    }
    
    @inlinable public init<S>(_ elements: S, as attribute: Attribute) where
    S: RandomAccessCollection, S.Element == Character {
        self._characters = String(elements)
        self._attributes = [Attribute](repeating: attribute, count: elements.count)
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
