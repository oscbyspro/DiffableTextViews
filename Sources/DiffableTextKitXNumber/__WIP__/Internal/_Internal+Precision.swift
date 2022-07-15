//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Internal x Precision
//*============================================================================*

#warning("Conformance?")
@usableFromInline protocol _Internal_Precision: _Style {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable var precision: NumberTextPrecision<Input>? { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Internal_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision(_ precision: NumberTextPrecision<Input>) -> Self {
        var result = self; result.precision = precision; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision(integer: Int) -> Self {
        self.precision(NumberTextPrecision(integer: integer...integer))
    }
    
    @inlinable public func precision(fraction: Int) -> Self {
        self.precision(NumberTextPrecision(fraction: fraction...fraction))
    }
    
    @inlinable public func precision(integer: Int, fraction: Int) -> Self {
        self.precision(NumberTextPrecision(integer: integer...integer, fraction: fraction...fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision<I>(integer: I, fraction: Int) -> Self
    where I: RangeExpression, I.Bound == Int {
        self.precision(NumberTextPrecision(integer: integer, fraction: fraction...fraction))
    }
    
    @inlinable public func precision<F>(integer: Int, fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        self.precision(NumberTextPrecision(integer: integer...integer, fraction: fraction))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision<I>(integer: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        self.precision(NumberTextPrecision(integer: integer))
    }
    
    @inlinable public func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        self.precision(NumberTextPrecision(fraction: fraction))
    }
    
    @inlinable public func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int {
        self.precision(NumberTextPrecision(integer: integer, fraction: fraction))
    }
}
