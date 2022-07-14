//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Style x Integer
//*============================================================================*

public protocol _Style_Integer {
        
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ length: Int) -> Self

    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<S>(_ limits: S) -> Self
    where S: RangeExpression, S.Bound == Int
}

//*============================================================================*
// MARK: * Style x Precision x Integer x Internal
//*============================================================================*

@usableFromInline protocol _Style_Integer_Internal: _Style_Integer, _Style_Precision_Internal { }

//=----------------------------------------------------------------------------=
// MARK: + Precision
//=----------------------------------------------------------------------------=

extension _Style_Integer_Internal {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision(_ length: Int) -> Self {
        self.precision(NumberTextPrecision(integer: length...length))
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision<I>(_ limits: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        self.precision(NumberTextPrecision(integer: limits))
    }
}
