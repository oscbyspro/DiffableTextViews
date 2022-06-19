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

public struct Offset<Encoding: DiffableTextKit.Encoding>: Comparable, ExpressibleByIntegerLiteral {
    
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
    public init(_ distance: Int, as encoding: Encoding.Type) {
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
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.distance < rhs.distance
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

//=----------------------------------------------------------------------------=
// MARK: + Character
//=----------------------------------------------------------------------------=

extension Offset where Encoding == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func character(_ distance: Int) -> Self {
        Self(distance)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UTF16
//=----------------------------------------------------------------------------=

extension Offset where Encoding == UTF16 {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func utf16(_ distance: Int) -> Self {
        Self(distance)
    }
}

//*============================================================================*
// MARK: * Offset x Int
//*============================================================================*

extension Int {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init<T>(_ offset: Offset<T>) {
        self = offset.distance
    }
}
