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

public protocol _Style_Precision: _Style {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(integer: Int) -> Self
    
    @inlinable func precision(fraction: Int) -> Self
    
    @inlinable func precision(integer: Int, fraction: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<I>(integer: I, fraction: Int) -> Self
    where I: RangeExpression, I.Bound == Int
    
    @inlinable func precision<F>(integer: Int, fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<I>(integer: I) -> Self
    where I: RangeExpression, I.Bound == Int
    
    @inlinable func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int
    
    @inlinable func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int
}

//*============================================================================*
// MARK: * Style x Precision x Integer
//*============================================================================*

public protocol _Style_Precision_Integer: _Style where Value: NumberTextValueXInteger {
        
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ length: Int) -> Self

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<S>(_ limits: S) -> Self
    where S: RangeExpression, S.Bound == Int
}

//*============================================================================*
// MARK: * Style x Precision x Internal
//*============================================================================*

@usableFromInline protocol _Internal_Style_Precision: _Style {
    typealias Precision = NumberTextPrecision<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var precision: Precision? { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Internal_Style_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: Precision) -> Self {
        var result = self; result.precision = precision; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision(integer: Int) -> Self {
        precision(Precision(integer: integer...integer))
    }
    
    @inlinable public func precision(fraction: Int) -> Self {
        precision(Precision(fraction: fraction...fraction))
    }
    
    @inlinable public func precision(integer: Int, fraction: Int) -> Self {
        precision(Precision(integer: integer...integer, fraction: fraction...fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision<I>(integer: I, fraction: Int) -> Self
    where I: RangeExpression, I.Bound == Int {
        precision(Precision(integer: integer, fraction: fraction...fraction))
    }
    
    @inlinable public func precision<F>(integer: Int, fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        precision(Precision(integer: integer...integer, fraction: fraction))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision<I>(integer: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        precision(Precision(integer: integer))
    }
    
    @inlinable public func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        precision(Precision(fraction: fraction))
    }
    
    @inlinable public func precision<I, F>(integer: I,  fraction: F) -> Self
    where I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int {
        precision(Precision(integer: integer, fraction: fraction))
    }
}

//*============================================================================*
// MARK: * Style x Precision x Integer x Internal
//*============================================================================*

@usableFromInline protocol _Internal_Style_Precision_Integer:
_Internal_Style_Precision, _Style_Precision_Integer { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Internal_Style_Precision_Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision(_ length: Int) -> Self {
        precision(Precision(integer: length...length))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision<I>(_ limits: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        precision(Precision(integer: limits))
    }
}
