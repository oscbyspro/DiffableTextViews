//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Offset
//*============================================================================*

public protocol Offset {
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
    //=------------------------------------------------------------------------=
    
    typealias Position = DiffableTextKit.Position<Self>
        
    @inlinable static func index(at position: Position, in characters: String) -> Index
    
    @inlinable static func position(at index: Index, in characters: String) -> Position
}

//=----------------------------------------------------------------------------=
// MARK: + Character
//=----------------------------------------------------------------------------=

extension Character: Offset {

    //=------------------------------------------------------------------------=
    // MARK: Index, Position
    //=------------------------------------------------------------------------=
    
    @inlinable public static func index(at position: Self.Position, in characters: String) -> Index {
        Index(characters.index(characters.startIndex, offsetBy: position.offset), as: position.offset)
    }
    
    @inlinable public static func position(at index: Index, in characters: String) -> Self.Position {
        Position(index.attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UTF16
//=----------------------------------------------------------------------------=

extension UTF16: Offset {
    
    //=------------------------------------------------------------------------=
    // MARK: Index, Position
    //=------------------------------------------------------------------------=
    
    @inlinable public static func index(at position: Self.Position, in characters: String) -> Index {
        let character = Swift.min(characters.endIndex,
        String.Index(utf16Offset: position.offset, in: characters))
        return Index(character, as: characters[..<character].count)
    }
    
    @inlinable public static func position(at index: Index, in characters: String) -> Self.Position {
        Position(characters[..<index.character].utf16.count)
    }
}
