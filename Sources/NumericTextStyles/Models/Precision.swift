//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Precision
//*============================================================================*

public struct Precision<Value: NumericTextValue>: Equatable {
    @usableFromInline typealias Namespace = _Precision
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lower: Count
    @usableFromInline let upper: Count
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.init(integer: Self.limits(\.integer), fraction: Self.limits(\.fraction))
    }
    
    @inlinable init<R>(integer:  R) where
    R: RangeExpression, R.Bound == Int {
        self.init(integer: integer, fraction: Self.limits(\.fraction))
    }
    
    @inlinable init<R>(fraction: R) where
    R: RangeExpression, R.Bound == Int {
        self.init(integer: Self.limits(\.integer), fraction: fraction)
    }
    
    @inlinable init<R0, R1>(integer: R0, fraction: R1) where
    R0: RangeExpression, R0.Bound == Int, R1: RangeExpression, R1.Bound == Int {
        let integer  = Namespace.interpret(integer,  in: Self.limits(\.integer ))
        let fraction = Namespace.interpret(fraction, in: Self.limits(\.fraction))
        //=--------------------------------------=
        // MARK: Initialize
        //=--------------------------------------=
        self.lower = Count(
        value: Namespace.minimum.value,
        integer:   integer .lowerBound,
        fraction:  fraction.lowerBound)
        self.upper = Count(
        value:   Value.precision.value,
        integer:   integer .upperBound,
        fraction:  fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func limits(_ component: (Count) -> Int) -> ClosedRange<Int> {
        component(Namespace.minimum)...component(Value.precision)
    }
}

//*============================================================================*
// MARK: * Precision x Namespace
//*============================================================================*

@usableFromInline enum _Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let minimum = Count(value: 1, integer: 1, fraction: 0)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func interpret<R: RangeExpression>(_ expression: R,
    in limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range = expression.relative(to: Int.min ..< Int.max)
        let lower = min(max(limits.lowerBound, range.lowerBound),     limits.upperBound)
        let upper = min(max(limits.lowerBound, range.upperBound - 1), limits.upperBound)
        return lower...upper
    }
}
