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
    
    @inlinable static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self>
    
    @inlinable static func index(at distance: Offset<Self>,
    from index: String.Index, in characters: some StringProtocol) -> String.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func distance(from start: Index,
    to end: Index, in snapshot: Snapshot) -> Offset<Self>
    
    @inlinable static func index(at distance: Offset<Self>,
    from index: Index, in snapshot: Snapshot) -> Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func distance(from start: Index,
    to end: Index, in snapshot: Snapshot) -> Offset<Self> {
        self.distance(from: start.character, to: end.character, in: snapshot.characters)
    }
    
    @inlinable public static func index(at distance: Offset<Self>,
    from index: Index, in snapshot: Snapshot) -> Index {
        var character  = self.index(at: distance, from: index.character, in: snapshot.characters)
        if  character != snapshot.characters.endIndex {
            character  = snapshot.characters.rangeOfComposedCharacterSequence(at: character).lowerBound
        }
        
        let stride = snapshot.characters.distance(from: index.character, to: character)
        let attribute = snapshot.attributes.index(index.attribute, offsetBy:    stride)
        return Index(character, as: attribute)
    }
}

//*============================================================================*
// MARK: * Encoding x Character
//*============================================================================*

extension Character: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) public static func index(at distance: Offset<Self>,
    from index: String.Index, in characters: some StringProtocol) -> String.Index {
        characters.index(index, offsetBy: Int(distance))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func distance(from start: Index,
    to end: Index, in snapshot: Snapshot) -> Offset<Self> {
        Offset(end.attribute - start.attribute)
    }
    
    @inlinable @inline(__always) public static func index(at distance: Offset<Self>,
    from index: Index, in snapshot: Snapshot) -> Index {
        snapshot.index(index, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x Unicode.Scalar
//*============================================================================*

extension Unicode.Scalar: Encoding {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.unicodeScalars.distance(from: start, to: end))
    }

    @inlinable @inline(__always) public static func index(at distance: Offset<Self>,
    from index: String.Index, in characters: some StringProtocol) -> String.Index {
        characters.unicodeScalars.index(index, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF16
//*============================================================================*

extension UTF16: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.utf16.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) public static func index(at distance: Offset<Self>,
    from index: String.Index, in characters: some StringProtocol) -> String.Index {
        characters.utf16.index(index, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF8
//*============================================================================*

extension UTF8: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.utf8.distance(from: start, to: end))
    }

    @inlinable @inline(__always) public static func index(at distance: Offset<Self>,
    from index: String.Index, in characters: some StringProtocol) -> String.Index {
        characters.utf8.index(index, offsetBy: Int(distance))
    }
}
