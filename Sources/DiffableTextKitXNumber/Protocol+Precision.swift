//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Protocol + Precision + Transformations
//*============================================================================*

extension NumberTextStyleProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: Precision) -> Self {
        var result = self; result.precision = precision; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer
//=----------------------------------------------------------------------------=

public extension NumberTextStyleProtocol where
Format.FormatInput: NumberTextValueXInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ length: Int) -> Self {
        precision(Precision(integer: length...length))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<I>(_ limits: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        precision(Precision(integer:  limits))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Any, Floating Point
//=----------------------------------------------------------------------------=

public extension NumberTextStyleProtocol {
    
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
    
    @inlinable func precision<I>(integer: I, fraction: Int) -> Self
    where I: RangeExpression, I.Bound == Int {
        precision(Precision(integer: integer, fraction: fraction...fraction))
    }
    
    @inlinable func precision<F>(integer: Int, fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        precision(Precision(integer: integer...integer, fraction: fraction))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<I>(integer: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        precision(Precision(integer: integer))
    }
    
    @inlinable func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        precision(Precision(fraction: fraction))
    }
    
    @inlinable func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int {
        precision(Precision(integer: integer, fraction: fraction))
    }
}
