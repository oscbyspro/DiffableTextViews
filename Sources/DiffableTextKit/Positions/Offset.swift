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

public struct Offset<Encoding>: Strideable,
AdditiveArithmetic, ExpressibleByIntegerLiteral
where Encoding: DiffableTextKit.Encoding {
        
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
// MARK: * Offset x Int
//*============================================================================*

public extension Int {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init<T>(_ offset: Offset<T>) {
        self = offset.distance
    }
}

//*============================================================================*
// MARK: * Offsets
//*============================================================================*

public protocol Offsets<Index>: Collection {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func distance<T>(
    from start: Index, to end: Index) -> Offset<T>
    
    @inlinable @inline(__always) func index(
    from start: Index, move distance: Offset<some Encoding>) -> Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension Offsets {
    
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
// MARK: * Offsets x String, String.SubSequence
//*============================================================================*

extension String: Offsets { }
extension String.SubSequence: Offsets { }
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
// MARK: * Offsets x Snapshot
//*============================================================================*

extension Snapshot: Offsets { }
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
