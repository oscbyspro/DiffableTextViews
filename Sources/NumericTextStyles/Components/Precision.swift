//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import struct Utilities.Cancellation
import   enum Foundation.NumberFormatStyleConfiguration

// MARK: - Precision

/// - Note: Lower precision bounds are enforced only when the view is idle.
public struct Precision<Value: Precise> {
    @usableFromInline typealias Implementation = PrecisionImplementation
    @usableFromInline typealias SignificantDigits = SignificantDigitsPrecision<Value>
    @usableFromInline typealias IntegerAndFractionLength = IntegerAndFractionLengthPrecision<Value>

    // MARK: Properties
    
    @usableFromInline let implementation: Implementation
    
    // MARK: Initializers
    
    @inlinable init(implementation: Implementation) {
        self.implementation = implementation
    }
    
    // MARK: Validation
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        try implementation.capacity(number: number)
    }
    
    // MARK: Styles

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        implementation.showcaseStyle()
    }
    
    @inlinable func editableStyle() -> NumberFormatStyleConfiguration.Precision {
        let integer = _Precision.minIntegerDigits...Value.maxLosslessIntegerDigits
        let fraction = _Precision.minFractionDigits...Value.maxLosslessFractionDigits
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> NumberFormatStyleConfiguration.Precision {
        let integerUpperBound = Swift.max(_Precision.minIntegerDigits, number.integer.count)
        let integer = _Precision.minIntegerDigits...integerUpperBound
        let fractionLowerBound = Swift.max(_Precision.minFractionDigits, number.fraction.count)
        let fraction = fractionLowerBound...fractionLowerBound
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
}

// MARK: - Implementation

@usableFromInline protocol PrecisionImplementation {

    // MARK: Requirements
            
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision
    
    @inlinable func capacity(number: Number) throws -> Capacity
}

// MARK: - SignificantDigitsPrecision

/// Evaluates significant digits.
@usableFromInline struct SignificantDigitsPrecision<Value: Precise>: PrecisionImplementation {

    // MARK: Properties
    
    @usableFromInline let significant: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(significant: R) where R.Bound == Int {
        self.significant = _Precision.clamped(significant, to: _Precision.minSignificantDigits...Value.maxLosslessSignificantDigits)
    }
    
    // MARK: Styles
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(significant)
    }
    
    // MARK: Capacity
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        let max = Capacity.max(in: Value.self, significant: significant.upperBound)
        return try _Precision.capacity(number: number, max: max)
    }
}

// MARK: - IntegerAndFractionLengthPrecision

/// Evaluates integer and fraction digits.
@usableFromInline struct IntegerAndFractionLengthPrecision<Value: Precise>: PrecisionImplementation {
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>

    // MARK: Properties
    
    @usableFromInline let integer: ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) where R0.Bound == Int, R1.Bound == Int {
        self.integer = _Precision.clamped(integer, to: _Precision.minIntegerDigits...Value.maxLosslessIntegerDigits)
        self.fraction = _Precision.clamped(fraction, to: _Precision.minFractionDigits...Value.maxLosslessFractionDigits)
    }
    
    @inlinable init<R: RangeExpression>(integer: R) where R.Bound == Int {
        self.init(integer: integer, fraction: _Precision.minFractionDigits...)
    }
    
    @inlinable init<R: RangeExpression>(fraction: R) where R.Bound == Int {
        self.init(integer: _Precision.minIntegerDigits..., fraction: fraction)
    }
    
    // MARK: Styles

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    // MARK: Capacity
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        let max = Capacity.max(in: Value.self, integer: integer.upperBound, fraction: fraction.upperBound)
        return try _Precision.capacity(number: number, max: max)
    }
}

// MARK: - Helpers

@usableFromInline enum _Precision {
    
    // MARK: Defaults
    
    @usableFromInline static let     minIntegerDigits: Int = 1
    @usableFromInline static let    minFractionDigits: Int = 0
    @usableFromInline static let minSignificantDigits: Int = 1

    // MARK: Bounds
    
    @inlinable static func clamped<R: RangeExpression>(_ expression: R, to limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range: Range<Int> = expression.relative(to: limits.lowerBound ..< limits.upperBound + 1)
        return Swift.max(limits.lowerBound, range.lowerBound) ... Swift.min(range.upperBound - 1, limits.upperBound)
    }
    
    // MARK: Capacity
        
    @inlinable static func capacity(number: Number, max: Capacity) throws -> Capacity {
        let integer = max.integer - number.integer.count
        guard integer >= 0 else {
            throw _Precision.cancellation(excess: .integer)
        }
        
        let fraction = max.fraction - number.fraction.count
        guard fraction >= 0 else {
            throw _Precision.cancellation(excess: .fraction)
        }
        
        let significant = max.significant - number.significantCount()
        guard significant >= 0 else {
            throw _Precision.cancellation(excess: .significant)
        }
        
        return .init(integer: integer, fraction: fraction, significant: significant)
    }
    
    // MARK: Errors
    
    @inlinable static func cancellation(excess component: Component) -> Cancellation {
        .init(reason: "Precision of \(component.rawValue) digits exceeded its capacity.")
    }
    
    // MARK: Components
    
    @usableFromInline enum Component: String {
        case integer
        case fraction
        case significant
    }
}

// MARK: - Instances: Significant

public extension Precision {

    // MARK: Digits
    
    @inlinable static func digits<R: RangeExpression>(_ significant: R) -> Self where R.Bound == Int {
        .init(implementation: SignificantDigits(significant: significant))
    }
    
    // MARK: Named
            
    @inlinable static var standard: Self {
        .init(implementation: SignificantDigits(significant: _Precision.minSignificantDigits...))
    }
}

// MARK: - Instances: IntegerAndFractionLength

public extension Precision where Value: PreciseFloatingPoint {
    
    // MARK: Digits

    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(implementation: IntegerAndFractionLength(integer: integer, fraction: fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(implementation: IntegerAndFractionLength(integer: integer, fraction: _Precision.minFractionDigits...))
    }
    
    @inlinable static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(implementation: IntegerAndFractionLength(integer: _Precision.minIntegerDigits..., fraction: fraction))
    }
}
