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

public struct Offset<Encoding: DiffableTextKit.Encoding>: Strideable,
AdditiveArithmetic, ExpressibleByIntegerLiteral {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var distance: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init(_ distance: Int) {
        self.distance = distance
    }
    
    @inlinable @inline(__always)
    public init(_ distance: Int, as type: Encoding.Type) {
        self.distance = distance
    }
    
    @inlinable @inline(__always)
    public init(integerLiteral distance: Int) {
        self.distance = distance
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func advanced(by units: Int) -> Self {
        Self(distance + units)
    }
    
    @inlinable @inline(__always)
    public func distance(to other: Self) -> Int {
        other.distance - distance
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.distance < rhs.distance
    }
    
    @inlinable @inline(__always)
    public static prefix func - (instance: Self) -> Self {
        Self(-instance.distance)
    }
    
    @inlinable @inline(__always)
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.distance + rhs.distance)
    }
    
    @inlinable @inline(__always)
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.distance - rhs.distance)
    }
    
    @inlinable @inline(__always)
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable @inline(__always)
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

//*============================================================================*
// MARK: * Offset x Int [...]
//*============================================================================*

public extension Int {
    
    @inlinable @inline(__always)
    init<T>(_ offset: Offset<T>) {
        self = offset.distance
    }
}

//*============================================================================*
// MARK: * Offsets [...]
//*============================================================================*

public protocol Offsets<Index>: Collection {
    
    @inlinable @inline(__always) func distance<T>(
    from start: Index, to end: Index) -> Offset<T>
    
    @inlinable @inline(__always) func index(
    from start: Index, move distance: Offset<some Encoding>) -> Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details [...]
//=----------------------------------------------------------------------------=

public extension Offsets {
    
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
    
    @inlinable @inline(__always) func index<T>(
    from start: Index, move distance: Offset<T>, as type: T.Type) -> Index {
        index(from: start, move: distance)
    }
    
    @inlinable @inline(__always) func index<T>(
    at distances: Offset<T>, as type: T.Type = T.self) -> Index {
        index(from: startIndex, move: distances)
    }
    
    @inlinable @inline(__always) func indices<T>(
    at distances: Range<Offset<T>>, as type: T.Type = T.self) -> Range<Index> {
        let lower = index(from: startIndex, move: distances.lowerBound)
        return lower ..< index(from: lower, move: Offset<T>(distances.count))
    }
}

//*============================================================================*
// MARK: * Offsets x String, String.SubSequence [...]
//*============================================================================*

extension String: Offsets { }
extension String.SubSequence: Offsets { }
public extension StringProtocol {
    
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
// MARK: * Offsets x Snapshot [...]
//*============================================================================*

extension Snapshot: Offsets { }
public extension Snapshot {
    
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
// MARK: * Encoding [...]
//*============================================================================*

public protocol Encoding {
    
    @inlinable @inline(__always) static func distance(
    from start: String.Index, to end: String.Index,
    in collection: some StringProtocol) -> Offset<Self>
    
    @inlinable @inline(__always) static func index(
    from start: String.Index, move distance: Offset<Self>,
    in collection: some StringProtocol) -> String.Index
    
    @inlinable @inline(__always) static func distance(
    from start: Snapshot.Index, to end: Snapshot.Index,
    in collection: Snapshot) -> Offset<Self>
    
    @inlinable @inline(__always) static func index(
    from start: Snapshot.Index, move distance: Offset<Self>,
    in collection: Snapshot) -> Snapshot.Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details [...]
//=----------------------------------------------------------------------------=

public extension Encoding {
    
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
// MARK: * Encoding x Character [...]
//*============================================================================*

extension Character: Encoding { }
public extension Character {
    
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
// MARK: * Encoding x Unicode.Scalar [...]
//*============================================================================*

extension Unicode.Scalar: Encoding { }
public extension Unicode.Scalar {
    
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
// MARK: * Encoding x UTF16 [...]
//*============================================================================*

extension UTF16: Encoding { }
public extension UTF16 {
    
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
// MARK: * Encoding x UTF8 [...]
//*============================================================================*

extension UTF8: Encoding { }
public extension UTF8 {
    
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
