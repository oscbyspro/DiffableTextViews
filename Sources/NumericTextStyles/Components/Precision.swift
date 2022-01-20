//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-17.
//

import DiffableTextViews
import Foundation
import Support

//*============================================================================*
// MARK: * Precision
//*============================================================================*

public struct Precision<Value: Precise> {
    @usableFromInline typealias Namespace = _Precision
    @usableFromInline typealias Style = _Precision.Style
    @usableFromInline typealias Configuration = NumberFormatStyleConfiguration.Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let style: Style
    @usableFromInline var lower: Count
    @usableFromInline var upper: Count
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init() {
        self.init(Self.limits(\.value))
    }

    @inlinable init<R: RangeExpression>(_ value: R)  where R.Bound == Int {
        let value = Namespace.interpret(value, in: Self.limits(\.value))
        //=--------------------------------------=
        // MARK: Set
        //=--------------------------------------=
        self.style = .value
        self.lower = Count(value: value.lowerBound, integer:   Namespace.min.integer, fraction:   Namespace.min.fraction)
        self.upper = Count(value: value.upperBound, integer: Value.precision.integer, fraction: Value.precision.fraction)
    }
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) where R0.Bound == Int, R1.Bound == Int {
        let integer  = Namespace.interpret(integer,  in: Self.limits( \.integer))
        let fraction = Namespace.interpret(fraction, in: Self.limits(\.fraction))
        //=--------------------------------------=
        // MARK: set
        //=--------------------------------------=
        self.style = .separate
        self.lower = Count(value:   Namespace.min.value, integer: integer.lowerBound, fraction: fraction.lowerBound)
        self.upper = Count(value: Value.precision.value, integer: integer.upperBound, fraction: fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Configurations
    //=------------------------------------------------------------------------=
    
    @inlinable func showcase() -> Configuration {
        switch style {
        case .separate: return .integerAndFractionLength(
             integerLimits: lower.integer  ... upper.integer,
            fractionLimits: lower.fraction ... upper.fraction)
        case .value: return .significantDigits(lower.value ... upper.value)
        }
    }

    @inlinable func editable() -> Configuration {
        .integerAndFractionLength(
         integerLimits: Namespace.min.integer  ... upper.integer,
        fractionLimits: Namespace.min.fraction ... upper.fraction)
    }
    
    @inlinable func editable(count: Count) -> Configuration {
        .integerAndFractionLength(
         integerLimits: max(Namespace.min.integer,  count.integer)  ... count.integer,
        fractionLimits: max(Namespace.min.fraction, count.fraction) ... count.fraction)
    }

    //=------------------------------------------------------------------------=
    // MARK: Capacity
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(count: Count) throws -> Count {
        let capacity = upper.map(&-, count)
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        guard capacity.value    >= 0 else { throw excess(.value)    }
        guard capacity.integer  >= 0 else { throw excess(.integer)  }
        guard capacity.fraction >= 0 else { throw excess(.fraction) }
        //=--------------------------------------=
        // MARK: Success
        //=--------------------------------------=
        return capacity
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Helpers
//=----------------------------------------------------------------------------=

extension Precision {

    //=------------------------------------------------------------------------=
    // MARK: Errors
    //=------------------------------------------------------------------------=
    
    @inlinable func excess(_ component: Count.Component) -> Info {
        Info([.mark(component), "digits exceed max precision", .mark(upper[component])])
    }
    
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
    
    //*========================================================================*
    // MARK: * Style
    //*========================================================================*
    
    @usableFromInline enum Style {
        case value
        case separate
    }
}
