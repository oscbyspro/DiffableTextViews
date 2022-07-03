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
    in characters: some StringProtocol) -> Offset<Self>
    
    @inlinable @inline(__always) static func index(
    at distance: Offset<Self>, from index: String.Index,
    in characters: some StringProtocol) -> String.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from  start: Snapshot.Index, to end: Snapshot.Index,
    in snapshot: Snapshot) -> Offset<Self>
    
    @inlinable @inline(__always) static func index(
    at distance: Offset<Self>, from index: Snapshot.Index,
    in snapshot: Snapshot) -> Snapshot.Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func distance(
    from  start: Snapshot.Index, to end: Snapshot.Index,
    in snapshot: Snapshot) -> Offset<Self> {
        distance(from: start.character, to: end.character, in: snapshot.characters)
    }
    
    @inlinable public static func index(
    at distance: Offset<Self>, from index: Snapshot.Index,
    in snapshot: Snapshot) -> Snapshot.Index {
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
    
    @inlinable @inline(__always) public static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) public static func index(
    at distance: Offset<Self>, from index: String.Index,
    in characters: some StringProtocol) -> String.Index {
        characters.index(index, offsetBy: Int(distance))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func distance(
    from  start: Snapshot.Index, to end: Snapshot.Index,
    in snapshot: Snapshot) -> Offset<Self> {
        Offset(end.attribute - start.attribute)
    }
    
    @inlinable @inline(__always) public static func index(
    at distance: Offset<Self>, from index: Snapshot.Index,
    in snapshot: Snapshot) -> Snapshot.Index {
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

    @inlinable @inline(__always) public static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.unicodeScalars.distance(from: start, to: end))
    }

    @inlinable @inline(__always) public static func index(
    at distance: Offset<Self>, from index: String.Index,
    in characters: some StringProtocol) -> String.Index {
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

    @inlinable @inline(__always) public static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.utf16.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) public static func index(
    at distance: Offset<Self>, from index: String.Index,
    in characters: some StringProtocol) -> String.Index {
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

    @inlinable @inline(__always) public static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.utf8.distance(from: start, to: end))
    }

    @inlinable @inline(__always) public static func index(
    at distance: Offset<Self>, from index: String.Index,
    in characters: some StringProtocol) -> String.Index {
        characters.utf8.index(index, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoded
//*============================================================================*

public protocol Encoded: Collection {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func offset<T>(
    from start: Index, to end: Index, as encoding: T.Type) -> Offset<T>
    
    @inlinable @inline(__always) func index<T>(
    at offset: Offset<T>, from start: Index) -> Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension Encoded {
    
    //=------------------------------------------------------------------------=
    // MARK: Offset
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func offset<T>(
    at index: Index, as encoding: T.Type = T.self) -> Offset<T> {
        offset(from: startIndex, to: index, as: encoding)
    }
    
    @inlinable @inline(__always) func offsets<T>(
    at indices: Range<Index>, as encoding: T.Type = T.self) -> Range<Offset<T>> {
        let lower = offset(from:         startIndex, to: indices.lowerBound, as: encoding)
        let count = offset(from: indices.lowerBound, to: indices.upperBound, as: encoding)
        return lower ..< lower + count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Index
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func index<T>(
    at offset: Offset<T>, as enconding: T.Type = T.self) -> Index {
        index(at: offset, from: startIndex)
    }
    
    @inlinable @inline(__always) func indices<T>(
    at offsets: Range<Offset<T>>, as enconding: T.Type = T.self) -> Range<Index> {
        let    lower   = index(at: offsets.lowerBound, from: startIndex)
        return lower ..< index(at: Offset<T>(offsets.count), from:lower)
    }
}

//*============================================================================*
// MARK: * Encoded x String
//*============================================================================*

extension String: Encoded {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public func offset<T>(
    from start: Index, to end: Index, as encoding: T.Type = T.self) -> Offset<T> {
        T.distance(from: start, to: end, in: self)
    }
    
    @inlinable @inline(__always) public func index<T>(
    at offset: Offset<T>, from start: Index) -> Index {
        T.index(at: offset, from: start, in: self)
    }
}

//*============================================================================*
// MARK: * Encoded x Snapshot
//*============================================================================*

extension Snapshot: Encoded {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public func offset<T>(
    from start: Index, to end: Index, as encoding: T.Type = T.self) -> Offset<T> {
        T.distance(from: start, to: end, in: self)
    }

    @inlinable @inline(__always) public func index<T>(
    at offset: Offset<T>, from start: Index) -> Index {
        T.index(at: offset, from: start, in: self)
    }
}
