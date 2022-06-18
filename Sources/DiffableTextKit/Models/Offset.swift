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
    
    @usableFromInline let distance: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ distance: Int) {
        self.distance = distance
    }
    
    @inlinable public init(integerLiteral distance: Int) {
        self.distance = distance
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.distance < rhs.distance
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.distance + rhs.distance)
    }
    
    @inlinable public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.distance - rhs.distance)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Character
//=----------------------------------------------------------------------------=

extension Offset where Encoding == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func character(_ distance: Int) -> Self {
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
    
    @inlinable public static func utf16(_ distance: Int) -> Self {
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
    
    @inlinable @inline(__always) public init<T>(_ offset: Offset<T>) {
        self = offset.distance
    }
}
