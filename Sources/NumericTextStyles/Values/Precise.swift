//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

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
