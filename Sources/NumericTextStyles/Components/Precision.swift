//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-17.
//

import Foundation
import Support

//*============================================================================*
// MARK: * Precision
//*============================================================================*

public struct Precision<Value: Precise>: Equatable {
    @usableFromInline typealias Namespace = _Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
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
        self.lower = Count(value:   Namespace.min.value, integer: integer.lowerBound, fraction: fraction.lowerBound)
        self.upper = Count(value: Value.precision.value, integer: integer.upperBound, fraction: fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Configurations
    //=------------------------------------------------------------------------=
    
    @inlinable func showcase() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: lower.integer  ... Int.max,
        fractionLimits: lower.fraction ... Int.max)
    }

    @inlinable func editable() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: Namespace.min.integer  ... upper.integer,
        fractionLimits: Namespace.min.fraction ... upper.fraction)
    }
    
    @inlinable func editable(count: Count) -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: max(Namespace.min.integer,  count.integer)  ... count.integer,
        fractionLimits: max(Namespace.min.fraction, count.fraction) ... count.fraction)
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
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Helpers
//=----------------------------------------------------------------------------=

extension Precision {

    //=------------------------------------------------------------------------=
    // MARK: Limits - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func limits(_ component: (Count) -> Int) -> ClosedRange<Int> {
        component(Namespace.min)...component(Value.precision)
    }
}

//*============================================================================*
// MARK: * Precision x Namespace
//*============================================================================*

@usableFromInline enum _Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let min = Count(value: 1, integer: 1, fraction: 0)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func interpret<R: RangeExpression>(_ expression: R,
        in limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range: Range<Int> = expression.relative(to: limits.lowerBound ..< limits.upperBound + 1)
        return Swift.max(limits.lowerBound, range.lowerBound) ... Swift.min(range.upperBound - 1, limits.upperBound)
    }
}
