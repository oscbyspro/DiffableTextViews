//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Options
//*============================================================================*

public extension OptionSet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func callAsFunction(_ mask: Bool) -> Self {
        mask ? self : Self()
    }
    
    @inlinable @inline(__always) static prefix func !(options: Self) -> Bool {
        options.isEmpty
    }
    
    @inlinable @inline(__always) static func + (lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }
    
    @inlinable @inline(__always) static func += (lhs: inout Self, rhs: Self) {
        lhs.formUnion(rhs)
    }
    
    @inlinable @inline(__always) static func - (lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs)
    }
    
    @inlinable @inline(__always) static func -= (lhs: inout Self, rhs: Self) {
        lhs.subtract(rhs)
    }
}
