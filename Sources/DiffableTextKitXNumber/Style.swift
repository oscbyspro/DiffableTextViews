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

public protocol _Style: DiffableTextStyle where Cache: NullableTextStyle,
Cache.Value == Input, Value == Graph.Value, Input: _Input {
    
    associatedtype Graph: _Graph
    
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
    // MARK: Any
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ bounds: Bounds?) -> Self {
        var result = self; result.bounds = bounds; return result
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
    // MARK: Any
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: Precision?) -> Self {
        var result = self; result.precision = precision; return result
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
    
    @inlinable func precision(integer: some RangeExpression<Int>,
    fraction: some RangeExpression<Int>) -> Self {
        precision(Precision(integer: integer, fraction: fraction))
    }
}
