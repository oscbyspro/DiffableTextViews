//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-17.
//

#warning("Add djustment method.")
#warning("Rename kind property.")


import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * Precision
//*============================================================================*

public struct WIP_Precision<Value: Precise> {
    @usableFromInline typealias Namespace = _WIP_Precision
    @usableFromInline typealias Style = _WIP_Precision.Style
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
        case .value:
            let value = upper.value ... upper.value
            return .significantDigits(value)
        case .separate:
            let integer  = upper.integer  ... upper.integer
            let fraction = upper.fraction ... upper.fraction
            return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable func editable() -> Configuration {
        let  integer = Swift.max(Namespace.min.integer,  upper .integer)
        let fraction = Swift.max(Namespace.min.fraction, upper.fraction)
        return .integerAndFractionLength(integer: integer, fraction: fraction)
    }
    
    @inlinable func editable(number: Number) -> Configuration {
        let  integer = Swift.max(Namespace.min.integer,  number .integer.count)
        let fraction = Swift.max(Namespace.min.fraction, number.fraction.count)
        return .integerAndFractionLength(integer: integer, fraction: fraction)
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
            throw excess(.integer)
        }
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        let fraction = upper.fraction - count.fraction
        guard fraction >= 0 else {
            throw excess(.fraction)
        }
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = upper.value - count.value
        guard value >= 0 else {
            throw excess(.value)
        }
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        return Count(value: value, integer: integer, fraction: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Errors
    //=------------------------------------------------------------------------=
    
    @inlinable func excess(_ component: Count.Component) -> Info {
        Info([.mark(component), "digits exceed max precision", .mark(upper[component])])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    #warning("...")
    @inlinable mutating func adapt<F: Format>(to format: F) {
        format.process(count: &upper)
        format.process(count: &upper)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Initializers - Helpers
//=----------------------------------------------------------------------------=

extension WIP_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable static func limits(_ component: (Count) -> Int) -> ClosedRange<Int> {
        component(Namespace.min)...component(Value.precision)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Initializers - Value
//=----------------------------------------------------------------------------=

extension WIP_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable static func digits<R: RangeExpression>(_ value: R) -> Self where R.Bound == Int {
        //=--------------------------------------=
        // MARK: Interpret
        //=--------------------------------------=
        let value = Namespace.clamped(value, to: Self.limits(\.value))
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
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    @inlinable static func digits(_ value: Int) -> Self {
        digits(value...value)
    }

    //=------------------------------------------------------------------------=
    // MARK: Standard
    //=------------------------------------------------------------------------=
            
    @inlinable static var standard: Self {
        .digits(limits(\.value))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Lengths
//=----------------------------------------------------------------------------=

#warning("WIP")
extension WIP_Precision where Value: PreciseFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable public static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        //=--------------------------------------=
        // MARK: Interpret
        //=--------------------------------------=
        let integer  = Namespace.clamped(integer,  to: limits( \.integer))
        let fraction = Namespace.clamped(fraction, to: limits(\.fraction))
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
    
    @inlinable public static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        digits(integer: integer, fraction: limits(\.fraction))
    }
    
    @inlinable public static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        digits(integer: limits(\.integer), fraction: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Static - Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable static func digits<R: RangeExpression>(integer: R, fraction: Int) -> Self where R.Bound == Int {
        digits(integer: integer, fraction: fraction...fraction)
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: Int, fraction: R) -> Self where R.Bound == Int {
        digits(integer: integer...integer, fraction: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Static - Length
    //=------------------------------------------------------------------------=
    
    @inlinable static func digits(integer: Int, fraction: Int) -> Self {
        digits(integer: integer...integer, fraction: fraction...fraction)
    }
    
    @inlinable static func digits(integer: Int) -> Self {
        digits(integer: integer...integer)
    }
    
    @inlinable static func digits(fraction: Int) -> Self {
        digits(fraction: fraction...fraction)
    }
}

//*============================================================================*
// MARK: * Precision x Namespace
//*============================================================================*

#warning("Clean this up.")
@usableFromInline enum _WIP_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let min = Count(value: 1, integer: 1, fraction: 0)
    
    //*========================================================================*
    // MARK: * Style
    //*========================================================================*
    
    @usableFromInline enum Style {
        case value
        case separate
    }
    
    @inlinable static func clamped<R: RangeExpression>(_ expression: R, to limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range: Range<Int> = expression.relative(to: limits.lowerBound ..< limits.upperBound + 1)
        return Swift.max(limits.lowerBound, range.lowerBound) ... Swift.min(range.upperBound - 1, limits.upperBound)
    }
}
