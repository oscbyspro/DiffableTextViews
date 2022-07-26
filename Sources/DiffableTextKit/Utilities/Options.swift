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
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable static prefix func !(instance: Self) -> Bool {
        instance.isEmpty
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func callAsFunction(_ mask: Bool) -> Self {
        mask ? self : Self()
    }
    
    @inlinable static func += (lhs: inout Self, rhs: Self) {
        lhs.formUnion(rhs)
    }
}
