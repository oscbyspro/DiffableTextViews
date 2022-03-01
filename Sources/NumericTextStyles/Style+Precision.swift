//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Style x Precision
//*============================================================================*

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: Precision) -> Self {
        var result = self; result.precision = precision; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer
//=----------------------------------------------------------------------------=

public extension NumericTextStyle where Value: NumericTextValue_Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ integer: Int) -> Self {
        precision(Precision(integer: integer...integer))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<R>(_ integer: R) -> Self where
    R: RangeExpression, R.Bound == Int {
        precision(Precision(integer: integer))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Float
//=----------------------------------------------------------------------------=

public extension NumericTextStyle where Value: NumericTextValue_FloatingPoint {
    
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
