//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Encoding
//*============================================================================*

public protocol Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
    //=------------------------------------------------------------------------=
            
    @inlinable static func index(at position: Position<Self>, in characters: String) -> Index
    
    @inlinable static func position(at index: Index, in characters: String) -> Position<Self>
}

//=----------------------------------------------------------------------------=
// MARK: + Character
//=----------------------------------------------------------------------------=

extension Character: Encoding {

    //=------------------------------------------------------------------------=
    // MARK: Index, Position
    //=------------------------------------------------------------------------=
    
    @inlinable public static func index(at position: Position<Self>, in characters: String) -> Index {
        Index(characters.index(characters.startIndex, offsetBy: position.offset), as: position.offset)
    }
    
    @inlinable public static func position(at index: Index, in characters: String) -> Position<Self> {
        Position(index.attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UTF16
//=----------------------------------------------------------------------------=

extension UTF16: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Index, Position
    //=------------------------------------------------------------------------=
    
    @inlinable public static func index(at position: Position<Self>, in characters: String) -> Index {
        let character = Swift.min(characters.endIndex,
        String.Index(utf16Offset: position.offset, in: characters))
        return Index(character, as: characters[..<character].count)
    }
    
    @inlinable public static func position(at index: Index, in characters: String) -> Position<Self> {
        Position(characters[..<index.character].utf16.count)
    }
}
