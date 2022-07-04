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

public extension Distance {
    
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
// MARK: * Distance x Character
//*============================================================================*

extension Character: Distance { }
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
// MARK: * Distance x Unicode.Scalar
//*============================================================================*

extension Unicode.Scalar: Distance { }
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

extension UTF16: Distance { }
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

extension UTF8: Distance { }
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

//*============================================================================*
// MARK: * Distances
//*============================================================================*

public protocol Distances<Index>: Collection {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func distance<T>(
    from start: Index, to end: Index) -> Offset<T>
    
    @inlinable @inline(__always) func index(
    from start: Index, move distance: Offset<some Distance>) -> Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension Distances {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) func distance<T>(
    from start: Index, to end: Index, as type: T.Type) -> Offset<T> {
        distance(from: start, to: end)
    }
    
    @inlinable @inline(__always) func distances<T>(
    to indices: Range<Index>, as type: T.Type = T.self) -> Range<Offset<T>> {
        let lower: Offset<T> = distance(from:         startIndex, to: indices.lowerBound)
        let count: Offset<T> = distance(from: indices.lowerBound, to: indices.upperBound)
        return lower ..< lower + count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func index<T>(
    from start: Index, move distance: Offset<T>, as type: T.Type) -> Index {
        index(from: start, move: distance)
    }
    
    @inlinable @inline(__always) func indices<T>(
    move distances: Range<Offset<T>>, as type: T.Type = T.self) -> Range<Index> {
        let lower = index(from: startIndex, move: distances.lowerBound)
        return lower ..< index(from: lower, move: Offset<T>(distances.count))
    }
}

//*============================================================================*
// MARK: * Distances x String, Substring
//*============================================================================*

extension String:     Distances { }
extension Substring:  Distances { }
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
