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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func index(
    at distance: Offset<Self>, from start: Index,
    in characters: some StringProtocol) -> Index
    
    @inlinable static func distance(
    from start: Index, to end: Index,
    in characters: some StringProtocol) -> Offset<Self>
}

//*============================================================================*
// MARK: * Encoding x Character
//*============================================================================*

extension Character: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func index(
    at distance: Offset<Self>, from start: Index,
    in characters: some StringProtocol) -> Index {
        let count = Int(distance)
        let character = characters.index(start.character, offsetBy: count)
        return Index(character, as: start.attribute + count)
    }
    
    @inlinable public static func distance(
    from start: Index,  to end: Index,
    in characters: some StringProtocol) -> Offset<Self> {
        return Offset(end.attribute - start.attribute)
    }
}

//*============================================================================*
// MARK: * Encoding x UTF16
//*============================================================================*

extension UTF16: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func index(
    at distance: Offset<Self>, from start: Index,
    in characters: some StringProtocol) -> Index {
        let character = min(
        characters.endIndex, // because Character ≤ UTF16 ≤ Character + 1
        characters.utf16.index(start.character, offsetBy: Int(distance)))
        let count = characters.distance(from: start.character, to: character)
        return Index(character, as: start.attribute + count)
    }
    
    @inlinable public static func distance(
    from start: Index,  to end: Index,
    in characters: some StringProtocol) -> Offset<Self> {
        return Offset(characters.utf16.distance(from: start.character, to: end.character))
    }
}
