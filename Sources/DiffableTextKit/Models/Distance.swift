//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Distance
//*============================================================================*

public protocol Distance {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self>
    
    @inlinable @inline(__always) static func index(
    from index: String.Index, move distance: Offset<Self>,
    in characters: some StringProtocol) -> String.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start:  Snapshot.Index, to end: Snapshot.Index,
    in snapshot: Snapshot) -> Offset<Self>
    
    @inlinable @inline(__always) static func index(
    from index:  Snapshot.Index, move distance: Offset<Self>,
    in snapshot: Snapshot) -> Snapshot.Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension Distance {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start:  Snapshot.Index, to end: Snapshot.Index,
    in snapshot: Snapshot) -> Offset<Self> {
        distance(from: start.character, to: end.character, in: snapshot.characters)
    }
    
    @inlinable static func index(
    from index:  Snapshot.Index, move distance: Offset<Self>,
    in snapshot: Snapshot) -> Snapshot.Index {
        var character  = self.index(from: index.character, move: distance, in: snapshot.characters)
        if  character != snapshot.characters.endIndex {
            character  = snapshot.characters.rangeOfComposedCharacterSequence(at: character).lowerBound
        }
        
        let stride = snapshot.characters.distance(from: index.character, to: character)
        let attribute = snapshot.attributes.index(index.attribute, offsetBy:    stride)
        return Snapshot.Index(character, as: attribute)
    }
}

//*============================================================================*
// MARK: * Distance x Character
//*============================================================================*

extension Character: Distance { }
public extension Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) static func index(
    from index: String.Index, move distance: Offset<Self>,
    in characters: some StringProtocol) -> String.Index {
        characters.index(index, offsetBy: Int(distance))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from  start: Snapshot.Index, to end: Snapshot.Index,
    in snapshot: Snapshot) -> Offset<Self> {
        Offset(end.attribute - start.attribute)
    }
    
    @inlinable @inline(__always) static func index(
    from index:  Snapshot.Index, move distance: Offset<Self>,
    in snapshot: Snapshot) -> Snapshot.Index {
        snapshot.index(index, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Distance x Unicode.Scalar
//*============================================================================*

extension Unicode.Scalar: Distance { }
public extension Unicode.Scalar {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.unicodeScalars.distance(from: start, to: end))
    }

    @inlinable @inline(__always) static func index(
    from index: String.Index, move distance: Offset<Self>,
    in characters: some StringProtocol) -> String.Index {
        characters.unicodeScalars.index(index, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF16
//*============================================================================*

extension UTF16: Distance { }
public extension UTF16 {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.utf16.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) static func index(
    from index: String.Index, move distance: Offset<Self>,
    in characters: some StringProtocol) -> String.Index {
        characters.utf16.index(index, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF8
//*============================================================================*

extension UTF8: Distance { }
public extension UTF8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.utf8.distance(from: start, to: end))
    }
    
    @inlinable @inline(__always) static func index(
    from index: String.Index, move distance: Offset<Self>,
    in characters: some StringProtocol) -> String.Index {
        characters.utf8.index(index, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Distances
//*============================================================================*

public protocol Distances<Index>: Collection {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func distance<T>(
    from start: Index, to end: Index) -> Offset<T>

    @inlinable @inline(__always) func index<T>(
    from start: Index, move distance: Offset<T>) -> Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension Distances {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) func distance<T>(
    from start: Index, to end: Index, as type: T.Type = T.self) -> Offset<T> {
        distance(from: start, to: end)
    }
    
    @inlinable @inline(__always) func distance<T>(
    at index: Index, as type: T.Type = T.self) -> Offset<T> {
        distance(from: startIndex, to: index, as: type)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func distances<T>(
    from start: Index, to indices: Range<Index>, as type: T.Type = T.self) -> Range<Offset<T>> {
        let lower = distance(from: start, to: indices.lowerBound, as: type)
        let count = distance(from: indices.lowerBound, to: indices.upperBound, as: type)
        return lower ..< lower + count
    }
    
    @inlinable @inline(__always) func distances<T>(
    at indices: Range<Index>, as type: T.Type = T.self) -> Range<Offset<T>> {
        distances(from: startIndex, to: indices)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func index<T>(
    from start: Index, move distance: Offset<T>, as type: T.Type = T.self) -> Index {
        index(from: start, move: distance)
    }
    
    @inlinable @inline(__always) func indices<T>(
    from start: Index, move distances: Range<Offset<T>>, as type: T.Type = T.self) -> Range<Index> {
        let    lower   = index(from: start, move: distances.lowerBound)
        return lower ..< index(from: lower, move: Offset<T>(distances.count))
    }
}

//*============================================================================*
// MARK: * Distances x String, Substring
//*============================================================================*

extension String: Distances { }
extension Substring: Distances { }
public extension StringProtocol {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) func distance<T>(
    from start: Index, to end: Index) -> Offset<T> {
        T.distance(from: start, to: end, in: self)
    }

    @inlinable @inline(__always) func index<T>(
    from start: Index, move distance: Offset<T>) -> Index {
        T.index(from: start, move: distance, in: self)
    }
}

//*============================================================================*
// MARK: * Distances x Snapshot
//*============================================================================*

extension Snapshot: Distances { }
public extension Snapshot {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) func distance<T>(
    from start: Index, to end: Index) -> Offset<T> {
        T.distance(from: start, to: end, in: self)
    }

    @inlinable @inline(__always) func index<T>(
    from start: Index, move distance: Offset<T>) -> Index {
        T.index(from: start, move: distance, in: self)
    }
}
