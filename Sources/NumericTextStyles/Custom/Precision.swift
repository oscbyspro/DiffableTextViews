//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import Foundation
import  Utilities

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
        .integerAndFractionLength(
            integerLimits:  Self.limits( \.integer),
            fractionLimits: Self.limits(\.fraction))
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
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        try implementation.capacity(number: number)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func limits(_ component: (Capacity) -> Int) -> ClosedRange<Int> {
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
        .init(SignificantDigits(limits(\.significant)))
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
    // MARK: Capacity
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let lowerBound = Capacity(integer: 1, fraction: 0, significant: 1)
    
    //
    // MARK: Capacity - Make
    //=------------------------------------------------------------------------=
    
    @inlinable static func capacity(number: Number, max: Capacity) throws -> Capacity {
        let integer = max.integer - number.integer.count
        guard integer >= 0 else {
            throw failure(excess: .integer, max: max.integer)
        }
        
        let fraction = max.fraction - number.fraction.count
        guard fraction >= 0 else {
            throw failure(excess: .fraction, max: max.fraction)
        }
        
        let significant = max.significant - number.significantCount()
        guard significant >= 0 else {
            throw failure(excess: .significant, max: max.significant)
        }
        
        return .init(integer: integer, fraction: fraction, significant: significant)
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
        case integer
        case fraction
        case significant
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
    // MARK: Capacity
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(number: Number) throws -> Capacity
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
        self.significant = _Precision.clamped(significant, to: Precision.limits(\.significant))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func showcaseStyle() -> _Precision.Style {
        .significantDigits(significant)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Capacity
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        var max = Value.precision
        max.significant = significant.upperBound
        return try _Precision.capacity(number: number, max: max)
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
    // MARK: Capacity
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(number: Number) throws -> Capacity {        
        var max = Value.precision
        max.integer  =  integer.upperBound
        max.fraction = fraction.upperBound
        return try _Precision.capacity(number: number, max: max)
    }
}