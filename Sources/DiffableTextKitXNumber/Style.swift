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
Cache.Value == Input, Value == Graph.Value {
    
    associatedtype Graph: _Graph
    
    typealias Input = Graph.Input
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ limits: ClosedRange<Input>) -> Self
    
    @inlinable func bounds(_ limits: PartialRangeFrom<Input>) -> Self
    
    @inlinable func bounds(_ limits: PartialRangeThrough<Input>) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ digits: some RangeExpression<Int>) -> Self
    
    @inlinable func precision(integer:  some RangeExpression<Int>) -> Self
    
    @inlinable func precision(fraction: some RangeExpression<Int>) -> Self
    
    @inlinable func precision(
    integer:  some RangeExpression<Int>,
    fraction: some RangeExpression<Int>) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension _Style {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ digits: Int) -> Self {
        precision(digits...digits)
    }
    
    @inlinable func precision(integer: Int) -> Self {
        precision(integer: integer...integer)
    }
    
    @inlinable func precision(fraction: Int) -> Self {
        precision(fraction: fraction...fraction)
    }
    
    @inlinable func precision(integer: Int, fraction: Int) -> Self {
        precision(integer: integer...integer, fraction: fraction...fraction)
    }
    
    @inlinable func precision(integer: some RangeExpression<Int>, fraction: Int) -> Self {
        precision(integer: integer, fraction: fraction...fraction)
    }
    
    @inlinable func precision(integer: Int, fraction: some RangeExpression<Int>) -> Self {
        precision(integer: integer...integer, fraction: fraction)
    }
}
