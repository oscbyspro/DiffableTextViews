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
// MARK: * Style
//*============================================================================*

public protocol _Style: DiffableTextStyle where Value: _Value {
    
    typealias Graph = Value.NumberTextGraph
    
    typealias Input = Graph.Input
    
    typealias Bounds = _Bounds<Input>
    
    typealias Precision = _Precision<Input>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: Bounds? { get set }
    
    @inlinable var precision: Precision? { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Bounds
//=----------------------------------------------------------------------------=

public extension _Style {
    
    //=------------------------------------------------------------------------=
    // MARK: Basic
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ bounds: Bounds?) -> Self {
        var S0 = self; S0.bounds = bounds; return S0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ limits: ClosedRange<Input>) -> Self {
        bounds(Bounds(limits))
    }
    
    @inlinable func bounds(_ limits: PartialRangeFrom<Input>) -> Self {
        bounds(Bounds(limits))
    }
    
    @inlinable func bounds(_ limits: PartialRangeThrough<Input>) -> Self {
        bounds(Bounds(limits))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Precision
//=----------------------------------------------------------------------------=

public extension _Style {
    
    //=------------------------------------------------------------------------=
    // MARK: Basic
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: Precision?) -> Self {
        var S0 = self; S0.precision = precision; return S0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Total
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ digits: Int) -> Self {
        precision(Precision(digits...digits))
    }
    
    @inlinable func precision(_ digits: some RangeExpression<Int>) -> Self {
        precision(Precision(digits))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Sides
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
    
    @inlinable func precision(integer: some RangeExpression<Int>) -> Self {
        precision(Precision(integer: integer))
    }
    
    @inlinable func precision(fraction: some RangeExpression<Int>) -> Self {
        precision(Precision(fraction: fraction))
    }
    
    @inlinable func precision(integer: some RangeExpression<Int>, fraction: Int) -> Self {
        precision(Precision(integer: integer, fraction: fraction...fraction))
    }
    
    @inlinable func precision(integer: Int, fraction: some RangeExpression<Int>) -> Self {
        precision(Precision(integer: integer...integer, fraction: fraction))
    }
    
    @inlinable func precision(integer: some RangeExpression<Int>, fraction: some RangeExpression<Int>) -> Self {
        precision(Precision(integer: integer, fraction: fraction))
    }
}
