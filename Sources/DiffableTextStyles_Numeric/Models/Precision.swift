//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

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
    
    @inlinable init(unchecked: (lower: Count, upper: Count)) {
        (self.lower, self.upper) = unchecked
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .unchecked()
    }
    
    @inlinable init<R>(integer:  R) where R: RangeExpression, R.Bound == Int {
        self = .unchecked(integer:  Self.interpret(integer,  as: \.integer ))
    }
    
    @inlinable init<R>(fraction: R) where R: RangeExpression, R.Bound == Int {
        self = .unchecked(fraction: Self.interpret(fraction, as: \.fraction))
    }
    
    @inlinable init<R0, R1>(integer: R0, fraction: R1) where
    R0: RangeExpression, R0.Bound == Int, R1: RangeExpression, R1.Bound == Int {
        self = .unchecked(integer:  Self.interpret(integer,  as: \.integer ),
                          fraction: Self.interpret(fraction, as: \.fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func unchecked(
    integer:  ClosedRange<Int> = limits(\.integer ),
    fraction: ClosedRange<Int> = limits(\.fraction)) -> Self {
        //=--------------------------------------=
        // MARK: Lower
        //=--------------------------------------=
        let lower = Count(
        value:  Namespace.lower.value,
        integer:  integer .lowerBound,
        fraction: fraction.lowerBound)
        //=--------------------------------------=
        // MARK: Upper
        //=--------------------------------------=
        let upper = Count(
        value:  Value.precision.value,
        integer:  integer .upperBound,
        fraction: fraction.upperBound)
        //=--------------------------------------=
        // MARK: Instantiate
        //=--------------------------------------=
        return Self(unchecked: (lower, upper))
    }
    
    @inlinable static func limits(_ component: (Count) -> Int) -> ClosedRange<Int> {
        component(Namespace.lower) ...
        component(Value.precision)
    }
    
    @inlinable static func interpret<R>(_ expression: R,
    as component: (Count) -> Int) -> ClosedRange<Int> where
    R: RangeExpression, R.Bound == Int {
        Namespace.interpret(expression, in: limits(component))
    }
}

//*============================================================================*
// MARK: * Precision x Namespace
//*============================================================================*

@usableFromInline enum _Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let lower = Count(value: 1, integer: 1, fraction: 0)
    
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

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Precision: Describable {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var descriptors: [(key: Any, value: Any)] {
        Count.components.map({($0, (self.lower[$0], self.upper[$0]))})
    }
}
