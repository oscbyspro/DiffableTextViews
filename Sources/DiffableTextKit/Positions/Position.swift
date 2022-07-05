//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Position
//*============================================================================*

public protocol Position: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func index(at position: Self,
    in collection: some Offsets<String.Index>) -> String.Index

    @inlinable @inline(__always) static func indices(at positions: Range<Self>,
    in collection: some Offsets<String.Index>) -> Range<String.Index>

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func index(at position: Self,
    in collection: some Offsets<Snapshot.Index>) -> Snapshot.Index
    
    @inlinable @inline(__always) static func indices(at positions: Range<Self>,
    in collection: some Offsets<Snapshot.Index>) -> Range<Snapshot.Index>
}

//*============================================================================*
// MARK: * Position x Snapshot.Index
//*============================================================================*

extension Snapshot.Index: Position { }
public extension Snapshot.Index {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func index(at position: Self,
    in collection: some Offsets<String.Index>) -> String.Index {
        position.character
    }
    
    @inlinable @inline(__always) static func indices(at positions: Range<Self>,
    in collection: some Offsets<String.Index>) -> Range<String.Index> {
        Range(uncheckedBounds:(positions.lowerBound.character,positions.upperBound.character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func index(at position: Self,
    in collection: some Offsets<Snapshot.Index>) -> Snapshot.Index {
        position
    }
    
    @inlinable @inline(__always) static func indices(at positions: Range<Self>,
    in collection: some Offsets<Snapshot.Index>) -> Range<Snapshot.Index> {
        positions
    }
}

//*============================================================================*
// MARK: * Position x Offset
//*============================================================================*

extension Offset: Position { }
public extension Offset {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func index(at position: Self,
    in collection: some Offsets<String.Index>) -> String.Index {
        collection.index(from: collection.startIndex, move: position)
    }
    
    @inlinable @inline(__always) static func indices(at positions: Range<Self>,
    in collection: some Offsets<String.Index>) -> Range<String.Index> {
        collection.indices(move: positions)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func index(at position: Self,
    in collection: some Offsets<Snapshot.Index>) -> Snapshot.Index {
        collection.index(from: collection.startIndex, move: position)
    }
    
    @inlinable @inline(__always) static func indices(at positions: Range<Self>,
    in collection: some Offsets<Snapshot.Index>) -> Range<Snapshot.Index> {
        collection.indices(move: positions)
    }
}

//*============================================================================*
// MARK: * Positions
//*============================================================================*

public protocol Positions<Index>: Offsets {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func index(at position: some Position) -> Index

    @inlinable @inline(__always) func indices(at positions: Range<some Position>) -> Range<Index>
}

//*============================================================================*
// MARK: * Positions x String, Substring
//*============================================================================*

extension String:    Positions { }
extension Substring: Positions { }
public extension StringProtocol where Self: Offsets {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) func index(at position: some Position) -> Index {
        type(of: position).index(at: position, in: self)
    }

    @inlinable @inline(__always) func indices(at positions: Range<some Position>) -> Range<Index> {
        type(of: positions).Bound.indices(at: positions,in: self)
    }
}

//*============================================================================*
// MARK: * Positions x Snapshot
//*============================================================================*

extension Snapshot: Positions { }
public extension Snapshot {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) func index(at position: some Position) -> Index {
        type(of: position).index(at: position, in: self)
    }

    @inlinable @inline(__always) func indices(at positions: Range<some Position>) -> Range<Index> {
        type(of: positions).Bound.indices(at: positions,in: self)
    }
}
