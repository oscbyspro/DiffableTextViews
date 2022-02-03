//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Precise
//*============================================================================*

public protocol Precise {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable static var precision: Count { get }
}

//*============================================================================*
// MARK: * Precise x Floating Point
//*============================================================================*

public protocol PreciseFloatingPoint: Precise { }

//=----------------------------------------------------------------------------=
// MARK: Precise x Floating Point - Utilities
//=----------------------------------------------------------------------------=

public extension PreciseFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision - Make
    //=------------------------------------------------------------------------=

    @inlinable static func precision(_ max: Int) -> Count {
        Count(value: max, integer: max, fraction: max)
    }
}

//*============================================================================*
// MARK: * Precise x Integer
//*============================================================================*

public protocol PreciseInteger: Precise { }

//=----------------------------------------------------------------------------=
// MARK: Precise x Integer - Utilities
//=----------------------------------------------------------------------------=

public extension PreciseInteger {
    
    //=------------------------------------------------------------------------
    // MARK: Precision - Make
    //=------------------------------------------------------------------------=
    
    @inlinable static func precision(_ max: Int) -> Count {
        Count(value: max, integer: max, fraction: .zero)
    }
}
