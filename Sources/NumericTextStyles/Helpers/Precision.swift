//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import DiffableTextViews
import Foundation

#warning("Percent showcase style is incorred.")

//*============================================================================*
// MARK: * Precision
//*============================================================================*

/// - Note: Lower bound is enforced only when the view is idle.
public struct Precision<Value: Precise> {
    @usableFromInline typealias Implementation = PrecisionImplementation
    @usableFromInline typealias SignificantDigits = SignificantDigitsPrecision<Value>
    @usableFromInline typealias IntegerAndFractionLength = IntegerAndFractionLengthPrecision<Value>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let implementation: Implementation
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ implementation: Implementation) {
        self.implementation = implementation
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=

    @inlinable func showcaseStyle() -> _Precision.Style {
        implementation.showcaseStyle()
    }
    
    @inlinable func editableStyle() -> _Precision.Style {
        .integerAndFractionLength(integerLimits: Self.limits(\.integer), fractionLimits: Self.limits(\.fraction))
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> _Precision.Style{
        let integerUpperBound = max(_Precision.lowerBound.integer, number.integer.count)
        let integer = _Precision.lowerBound.integer...integerUpperBound
        let fractionLowerBound = max(_Precision.lowerBound.fraction, number.fraction.count)
        let fraction = fractionLowerBound...fractionLowerBound
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(count: Count) throws -> Count {
        try implementation.capacity(count: count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func limits(_ component: (Count) -> Int) -> ClosedRange<Int> {
        component(_Precision.lowerBound)...component(Value.precision)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Initializers - Significant Digits
//=----------------------------------------------------------------------------=

public extension Precision {

    //=------------------------------------------------------------------------
    // MARK: Static - Limits
    //=------------------------------------------------------------------------=
    
    @inlinable static func digits<R: RangeExpression>(_ significant: R) -> Self where R.Bound == Int {
        .init(SignificantDigits(significant))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Static - Length
    //=------------------------------------------------------------------------=
    
    @inlinable static func digits(_ significant: Int) -> Self {
        self.init(SignificantDigits(significant...significant))
    }

    //=------------------------------------------------------------------------=
    // MARK: Static - Named
    //=------------------------------------------------------------------------=
            
    @inlinable static var standard: Self {
        .init(SignificantDigits(limits(\.value)))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Initializers - Integer And Fraction Length
//=----------------------------------------------------------------------------=

public extension Precision where Value: PreciseFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Static - Limits
    //=------------------------------------------------------------------------=

    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(IntegerAndFractionLength(integer: integer, fraction: fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(IntegerAndFractionLength(integer: integer))
    }
    
    @inlinable static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(IntegerAndFractionLength(fraction: fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Static - Mixed
    //=------------------------------------------------------------------------=
    
    @inlinable static func digits<R: RangeExpression>(integer: R, fraction: Int) -> Self where R.Bound == Int {
        .init(IntegerAndFractionLength(integer: integer, fraction: fraction...fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: Int, fraction: R) -> Self where R.Bound == Int {
        .init(IntegerAndFractionLength(integer: integer...integer, fraction: fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Static - Length
    //=------------------------------------------------------------------------=
    
    @inlinable static func digits(integer: Int, fraction: Int) -> Self {
        .init(IntegerAndFractionLength(integer: integer...integer, fraction: fraction...fraction))
    }
    
    @inlinable static func digits(integer: Int) -> Self {
        .init(IntegerAndFractionLength(integer: integer...integer))
    }
    
    @inlinable static func digits(fraction: Int) -> Self {
        .init(IntegerAndFractionLength(fraction: fraction...fraction))
    }
}

//*============================================================================*
// MARK: * Precision x Namespace
//*============================================================================*

@usableFromInline enum _Precision {
    @usableFromInline typealias Style = NumberFormatStyleConfiguration.Precision

    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable static func clamped<R: RangeExpression>(_ expression: R, to limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range: Range<Int> = expression.relative(to: limits.lowerBound ..< limits.upperBound + 1)
        return Swift.max(limits.lowerBound, range.lowerBound) ... Swift.min(range.upperBound - 1, limits.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let lowerBound = Count(value: 1, integer: 1, fraction: 0)
    
    //
    // MARK: Count - Make
    //=------------------------------------------------------------------------=
    
    @inlinable static func capacity(count: Count, max: Count) throws -> Count {
        let integer = max.integer - count.integer
        guard integer >= 0 else {
            throw failure(excess: .integer, max: max.integer)
        }
        
        let fraction = max.fraction - count.fraction
        guard fraction >= 0 else {
            throw failure(excess: .fraction, max: max.fraction)
        }
        
        let value = max.value - count.fraction
        guard value >= 0 else {
            throw failure(excess: .value, max: max.value)
        }
        
        return Count(value: value, integer: integer, fraction: fraction)
    }

    //=------------------------------------------------------------------------=
    // MARK: Errors
    //=------------------------------------------------------------------------=
    
    @inlinable static func failure(excess component: Component, max: Int) -> Info {
        Info([.mark(component), "digits exceed precision capacity of", .mark(max)])
    }
    
    //*========================================================================*
    // MARK: * Components
    //*========================================================================*
    
    @usableFromInline enum Component: String {
        case value
        case integer
        case fraction
    }
}

//*============================================================================*
// MARK: * Precision x Implementation
//*============================================================================*

@usableFromInline protocol PrecisionImplementation {

    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
            
    @inlinable func showcaseStyle() -> _Precision.Style
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(count: Count) throws -> Count
}

//*============================================================================*
// MARK: * Precision x Significant Digits
//*============================================================================*

@usableFromInline struct SignificantDigitsPrecision<Value: Precise>: PrecisionImplementation {
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let significant: ClosedRange<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<R: RangeExpression>(_ significant: R) where R.Bound == Int {
        self.significant = _Precision.clamped(significant, to: Precision.limits(\.value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func showcaseStyle() -> _Precision.Style {
        .significantDigits(significant)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(count: Count) throws -> Count {
        var max = Value.precision
        max.value = significant.upperBound
        return try _Precision.capacity(count: count, max: max)
    }
}

//*============================================================================*
// MARK: * Precision x Integer And Fraction Length
//*============================================================================*

@usableFromInline struct IntegerAndFractionLengthPrecision<Value: Precise>: PrecisionImplementation {
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let integer:  ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) where R0.Bound == Int, R1.Bound == Int {
        self.integer  = _Precision.clamped(integer,  to: Precision.limits( \.integer))
        self.fraction = _Precision.clamped(fraction, to: Precision.limits(\.fraction))
    }
    
    @inlinable init<R: RangeExpression>(integer: R) where R.Bound == Int {
        self.init(integer: integer, fraction: Precision.limits(\.fraction))
    }
    
    @inlinable init<R: RangeExpression>(fraction: R) where R.Bound == Int {
        self.init(integer: Precision.limits(\.integer), fraction: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=

    @inlinable func showcaseStyle() -> _Precision.Style {
        .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(count: Count) throws -> Count {
        var max = Value.precision
        max.integer  =  integer.upperBound
        max.fraction = fraction.upperBound
        return try _Precision.capacity(count: count, max: max)
    }
}
