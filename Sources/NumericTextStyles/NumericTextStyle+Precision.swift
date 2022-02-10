//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Precision
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func transform(_ precision: Precision) -> Self {
        var result = self; result.precision = precision; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Integer
//=----------------------------------------------------------------------------=

public extension NumericTextStyle where Value: NumericTextIntegerValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ integer: Int) -> Self {
        precision(integer...integer)
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<R: RangeExpression>(_ integer: R) -> Self where R.Bound == Int {
        transform(Precision(integer: integer, fraction: Precision.limits(\.fraction)))
    }
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Floating Point
//=----------------------------------------------------------------------------=

public extension NumericTextStyle where Value: NumericTextFloatingPointValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(integer: Int) -> Self {
        precision(integer: integer...integer)
    }
    
    @inlinable func precision(fraction: Int) -> Self {
        precision(fraction: fraction...fraction)
    }
    
    @inlinable func precision(integer: Int, fraction: Int) -> Self {
        precision(integer: integer...integer, fraction: fraction...fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<R: RangeExpression>(integer: R, fraction: Int) -> Self where R.Bound == Int {
        precision(integer: integer, fraction: fraction...fraction)
    }
    
    @inlinable func precision<R: RangeExpression>(integer: Int, fraction: R) -> Self where R.Bound == Int {
        precision(integer: integer...integer, fraction: fraction)
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        precision(integer: integer, fraction: Precision.limits(\.fraction))
    }
    
    @inlinable func precision<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        precision(integer: Precision.limits(\.integer), fraction: fraction)
    }
    
    @inlinable func precision<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        transform(Precision(integer: integer, fraction: fraction))
    }
}
