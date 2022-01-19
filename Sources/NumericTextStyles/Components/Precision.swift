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

public struct Precision<Format: NumericTextStyles.Format> {
    public typealias Value = Format.FormatInput
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
    
    @inlinable init(style: Style, lower: Count, upper: Count) {
        self.style = style
        self.lower = lower
        self.upper = upper
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Showcase
    //=------------------------------------------------------------------------=
    
    @inlinable func showcase() -> Configuration {
        switch style {
        case .value:    return value()
        case .separate: return separate()
        }
    }
    
    @inlinable func value() -> Configuration {
        .significantDigits(lower.value ... upper.value)
    }
    
    @inlinable func separate() -> Configuration {
        .integerAndFractionLength(
         integerLimits: lower .integer ... upper .integer,
        fractionLimits: lower.fraction ... upper.fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable func editable() -> Configuration {
        editable(count: upper)
    }
    
    @inlinable func editable(count: Count) -> Configuration {
        .integerAndFractionLength(
         integerLimits: Namespace.min.integer  ... count.integer,
        fractionLimits: Namespace.min.fraction ... count.fraction)
    }

    //=------------------------------------------------------------------------=
    // MARK: Capacity
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(count: Count) throws -> Count {
        //=--------------------------------------=
        // MARK: Integer
        //=--------------------------------------=
        let integer = upper.integer - count.integer
        guard integer >= 0 else {
            throw excess(\.integer)
        }
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        let fraction = upper.fraction - count.fraction
        guard fraction >= 0 else {
            throw excess(\.fraction)
        }
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = upper.value - count.value
        guard value >= 0 else {
            throw excess(\.value)
        }
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        return Count(value: value, integer: integer, fraction: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Errors
    //=------------------------------------------------------------------------=
    
    @inlinable func excess(_ component: (Count) -> Int) -> Info { .init {
        let template = Count(value: 0, integer: 1, fraction: 2)
        let value = component(template); let mirror = Mirror(reflecting: template)
        let label = mirror.children.first(where: { $0.value as? Int == value })?.label
        return [.mark(label!), "digits exceed max precision", .mark(component(upper))]
    } }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Initializers - Value
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Standard
    //=------------------------------------------------------------------------=
            
    @inlinable public static var standard: Self {
        limits(max(\.value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable public static func limits(_ value: Int) -> Self {
        limits(value...value)
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public static func limits<R: RangeExpression>(_ value: R) -> Self where R.Bound == Int {
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = Namespace.interpret(value, in: max(\.value))
        //=--------------------------------------=
        // MARK: Limits
        //=--------------------------------------=
        let lower = Count(value: value.lowerBound, integer:   Namespace.min.integer, fraction:   Namespace.min.fraction)
        let upper = Count(value: value.upperBound, integer: Value.precision.integer, fraction: Value.precision.fraction)
        //=--------------------------------------=
        // MARK: Instance
        //=--------------------------------------=
        return Self(style: .value, lower: lower, upper: upper)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Lengths
//=----------------------------------------------------------------------------=

extension Precision where Value: PreciseFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable public static func limits(integer: Int) -> Self {
        limits(integer: integer...integer)
    }
    
    @inlinable public static func limits(fraction: Int) -> Self {
        limits(fraction: fraction...fraction)
    }
    
    @inlinable public static func limits(integer: Int, fraction: Int) -> Self {
        limits(integer: integer...integer, fraction: fraction...fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable public static func limits<R: RangeExpression>(integer: R, fraction: Int) -> Self where R.Bound == Int {
        limits(integer: integer, fraction: fraction...fraction)
    }
    
    @inlinable public static func limits<R: RangeExpression>(integer: Int, fraction: R) -> Self where R.Bound == Int {
        limits(integer: integer...integer, fraction: fraction)
    }

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public static func limits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        limits(integer: integer, fraction: max(\.fraction))
    }
    
    @inlinable public static func limits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        limits(integer: max(\.integer), fraction: fraction)
    }
    
    @inlinable public static func limits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        //=--------------------------------------=
        // MARK: Integer, Fraction
        //=--------------------------------------=
        let integer  = Namespace.interpret(integer,  in: max( \.integer))
        let fraction = Namespace.interpret(fraction, in: max(\.fraction))
        //=--------------------------------------=
        // MARK: Limits
        //=--------------------------------------=
        let lower = Count(value:   Namespace.min.value, integer: integer.lowerBound, fraction: fraction.lowerBound)
        let upper = Count(value: Value.precision.value, integer: integer.upperBound, fraction: fraction.upperBound)
        //=--------------------------------------=
        // MARK: Instance
        //=--------------------------------------=
        return Self(style: .separate, lower: lower, upper: upper)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Helpers - Static
//=----------------------------------------------------------------------------=

extension Precision {

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable static func max(_ component: (Count) -> Int) -> ClosedRange<Int> {
        component(Namespace.min)...component(Format.precision)
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
    
    @inlinable static func interpret<R: RangeExpression>(_ expression: R, in limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
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
