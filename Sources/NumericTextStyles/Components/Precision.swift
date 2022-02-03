//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import Support

//*============================================================================*
// MARK: * Precision
//*============================================================================*

public struct Precision<Value: Precise>: Equatable {
    @usableFromInline typealias Namespace = _Precision
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var lower: Count
    @usableFromInline var upper: Count
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init() {
        self.init(integer: Self.limits(\.integer), fraction: Self.limits(\.fraction))
    }

    @inlinable init<R0: RangeExpression, R1: RangeExpression>(integer: R0,
        fraction: R1) where R0.Bound == Int, R1.Bound == Int {
        let integer  = Namespace.interpret(integer,  in: Self.limits(\.integer ))
        let fraction = Namespace.interpret(fraction, in: Self.limits(\.fraction))
        //=--------------------------------------=
        // MARK: Set
        //=--------------------------------------=
        self.lower = Count(value: Namespace.minimum.value, integer: integer.lowerBound, fraction: fraction.lowerBound)
        self.upper = Count(value:   Value.precision.value, integer: integer.upperBound, fraction: fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Modes
    //=------------------------------------------------------------------------=
    
    @inlinable func inactive() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: lower.integer  ... upper.integer,
        fractionLimits: lower.fraction ... upper.fraction)
    }

    @inlinable func active() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: Namespace.minimum.integer  ... upper.integer,
        fractionLimits: Namespace.minimum.fraction ... upper.fraction)
    }
    
    @inlinable func interactive(count: Count) -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: max(Namespace.minimum.integer,  count.integer)  ... count.integer,
        fractionLimits: max(Namespace.minimum.fraction, count.fraction) ... count.fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Capacity
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(count: Count) throws -> Count {
        let capacity = upper.transform(&-, count)
        //=--------------------------------------=
        // MARK: Validate Each Component
        //=--------------------------------------=
        if let component = capacity.first(where: { $0 < 0 }) {
            throw Info([.mark(component), "digits exceed max precision", .mark(upper[component])])
        }
        //=--------------------------------------=
        // MARK: Return Capacity On Success
        //=--------------------------------------=
        return capacity
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        number.trim(max: upper)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Helpers
//=----------------------------------------------------------------------------=

extension Precision {

    //=------------------------------------------------------------------------=
    // MARK: Limits - Static
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
