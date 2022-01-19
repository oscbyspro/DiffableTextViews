//
//  NumericTextStyle+Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-19.
//

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Precision
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision(_ precision: Precision) -> Self {
        var result = self; result.precision = precision; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Precision - Value
//=----------------------------------------------------------------------------=

public extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision(_ value: Int) -> Self {
        precision(value...value)
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision<R: RangeExpression>(_ value: R) -> Self where R.Bound == Int {
        precision(Precision(value))
    }
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Precision - Integer, Fraction
//=----------------------------------------------------------------------------=

public extension NumericTextStyle where Value: PreciseFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision(integer: Int) -> Self {
        precision(integer: integer...integer)
    }
    
    @inlinable @inline(__always) func precision(fraction: Int) -> Self {
        precision(fraction: fraction...fraction)
    }
    
    @inlinable @inline(__always) func precision(integer: Int, fraction: Int) -> Self {
        precision(integer: integer...integer, fraction: fraction...fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision<R: RangeExpression>(integer: R, fraction: Int) -> Self where R.Bound == Int {
        precision(integer: integer, fraction: fraction...fraction)
    }
    
    @inlinable @inline(__always) func precision<R: RangeExpression>(integer: Int, fraction: R) -> Self where R.Bound == Int {
        precision(integer: integer...integer, fraction: fraction)
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        precision(integer: integer, fraction: Precision.limits(\.fraction))
    }
    
    @inlinable @inline(__always) func precision<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        precision(integer: Precision.limits(\.integer), fraction: fraction)
    }
    
    @inlinable @inline(__always) func precision<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        precision(Precision(integer: integer, fraction: fraction))
    }
}
