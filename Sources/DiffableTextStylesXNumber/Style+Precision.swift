//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Precision
//*============================================================================*

internal extension NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: Precision) -> Self {
        var result = self; result.precision = precision; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: Integer
//=----------------------------------------------------------------------------=

public extension NumberTextStyle where Value: NumberTextValueXInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ length: Int) -> Self {
        precision(Precision(integer: length...length))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<R>(_ limits: R) -> Self where
    R: RangeExpression, R.Bound == Int {
        precision(Precision(integer: limits))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Floating Point
//=----------------------------------------------------------------------------=

public extension NumberTextStyle where Value: NumberTextValueXFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(integer: Int) -> Self {
        precision(Precision(integer: integer...integer))
    }
    
    @inlinable func precision(fraction: Int) -> Self {
        precision(Precision(fraction: fraction...fraction))
    }
    
    @inlinable func precision(integer: Int, fraction: Int) -> Self {
        precision(Precision(integer: integer...integer, fraction: fraction...fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<R>(integer: R, fraction: Int) -> Self where
    R: RangeExpression, R.Bound == Int {
        precision(Precision(integer: integer, fraction: fraction...fraction))
    }
    
    @inlinable func precision<R>(integer: Int, fraction: R) -> Self where
    R: RangeExpression, R.Bound == Int {
        precision(Precision(integer: integer...integer, fraction: fraction))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<R>(integer: R) -> Self where
    R: RangeExpression, R.Bound == Int {
        precision(Precision(integer: integer))
    }
    
    @inlinable func precision<R>(fraction: R) -> Self where
    R: RangeExpression, R.Bound == Int {
        precision(Precision(fraction: fraction))
    }
    
    @inlinable func precision<R0, R1>(integer: R0, fraction: R1) -> Self where
    R0: RangeExpression, R0.Bound == Int, R1: RangeExpression, R1.Bound == Int {
        precision(Precision(integer: integer, fraction: fraction))
    }
}
