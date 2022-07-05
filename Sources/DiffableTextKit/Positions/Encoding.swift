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
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in collection: some StringProtocol) -> Offset<Self>
    
    @inlinable @inline(__always) static func index(
    from start: String.Index, move distance: Offset<Self>,
    in collection: some StringProtocol) -> String.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: Snapshot.Index, to end: Snapshot.Index,
    in collection: Snapshot) -> Offset<Self>
    
    @inlinable @inline(__always) static func index(
    from start: Snapshot.Index, move distance: Offset<Self>,
    in collection: Snapshot) -> Snapshot.Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: Snapshot.Index, to end: Snapshot.Index,
    in collection: Snapshot) -> Offset<Self> {
        distance(from: start.character, to: end.character, in: collection.characters)
    }
    
    @inlinable static func index(
    from start: Snapshot.Index, move distance: Offset<Self>,
    in collection: Snapshot) -> Snapshot.Index {
        var character  = index(from: start.character, move: distance, in: collection.characters)
        if  character != collection.characters.endIndex {
            character  = collection.characters.rangeOfComposedCharacterSequence(at: character).lowerBound
        }
        
        let stride = collection.characters.distance(from: start.character, to: character)
        let attribute = collection.attributes.index(start.attribute, offsetBy:    stride)
        return Snapshot.Index(character, as: attribute)
    }
}

//*============================================================================*
// MARK: * Encoding x Character
//*============================================================================*

extension Character: Encoding { }
public extension Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in collection: some StringProtocol) -> Offset<Self> {
        Offset(collection.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) static func index(
    from start: String.Index, move distance: Offset<Self>,
    in collection: some StringProtocol) -> String.Index {
        collection.index(start, offsetBy: Int(distance))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: Snapshot.Index, to end: Snapshot.Index,
    in collection: Snapshot) -> Offset<Self> {
        Offset(end.attribute - start.attribute)
    }
    
    @inlinable @inline(__always) static func index(
    from start: Snapshot.Index, move distance: Offset<Self>,
    in collection: Snapshot) -> Snapshot.Index {
        collection.index(start, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x Unicode.Scalar
//*============================================================================*

extension Unicode.Scalar: Encoding { }
public extension Unicode.Scalar {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in collection: some StringProtocol) -> Offset<Self> {
        Offset(collection.unicodeScalars.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) static func index(
    from start: String.Index, move distance: Offset<Self>,
    in collection: some StringProtocol) -> String.Index {
        collection.unicodeScalars.index(start, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF16
//*============================================================================*

extension UTF16: Encoding { }
public extension UTF16 {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in collection: some StringProtocol) -> Offset<Self> {
        Offset(collection.utf16.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) static func index(
    from start: String.Index, move distance: Offset<Self>,
    in collection: some StringProtocol) -> String.Index {
        collection.utf16.index(start, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF8
//*============================================================================*

extension UTF8: Encoding { }
public extension UTF8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in collection: some StringProtocol) -> Offset<Self> {
        Offset(collection.utf8.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) static func index(
    from start: String.Index, move distance: Offset<Self>,
    in collection: some StringProtocol) -> String.Index {
        collection.utf8.index(start, offsetBy: Int(distance))
    }
}
