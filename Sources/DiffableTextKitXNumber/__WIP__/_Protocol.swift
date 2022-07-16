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
// MARK: * Protocol
//*============================================================================*

public protocol _Protocol: DiffableTextStyle where Value: NumberTextKind {
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
    
    @inlinable func precision(integer: Int) -> Self
    
    @inlinable func precision(fraction: Int) -> Self
    
    @inlinable func precision(integer: Int, fraction: Int) -> Self
    
    @inlinable func precision<I>(integer: I, fraction: Int) -> Self
    where I: RangeExpression, I.Bound == Int
    
    @inlinable func precision<F>(integer: Int, fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int
    
    @inlinable func precision<I>(integer: I) -> Self
    where I: RangeExpression, I.Bound == Int
    
    @inlinable func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int
    
    @inlinable func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Input: Integer
//=----------------------------------------------------------------------------=

public extension _Protocol where Input: _Value_Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ length: Int) -> Self {
        self.precision(integer: length...length)
    }

    @inlinable func precision<I>(_ limits: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        self.precision(integer: limits)
    }
}

//*============================================================================*
// MARK: * Protocol x Internal
//*============================================================================*

@usableFromInline protocol _Protocol_Internal: _Protocol {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: NumberTextBounds<Input>? { get set }
    @inlinable var precision: NumberTextPrecision<Input>? { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Bounds
//=----------------------------------------------------------------------------=

extension _Protocol_Internal {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ bounds: NumberTextBounds<Input>) -> Self {
        var result = self; result.bounds = bounds; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func bounds(_ limits: ClosedRange<Input>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeFrom<Input>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeThrough<Input>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Precision
//=----------------------------------------------------------------------------=

extension _Protocol_Internal {
    
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
