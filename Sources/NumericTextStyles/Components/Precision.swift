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
    @usableFromInline typealias Significant = SignificantPrecision<Value>
    @usableFromInline typealias IntegerAndFraction = IntegerAndFractionPrecision<Value>

    // MARK: Properties
    
    @usableFromInline let implementation: PrecisionImplementation
    
    // MARK: Initializers
    
    @inlinable init(implementation: PrecisionImplementation) {
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
        let integer = _Precision.integerLowerBound...Value.maxLosslessUpperDigits
        let fraction = _Precision.fractionLowerBound...Value.maxLosslessLowerDigits
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> NumberFormatStyleConfiguration.Precision {
        let integerUpperBound = Swift.max(_Precision.integerLowerBound, number.integer.count)
        let integer = _Precision.integerLowerBound...integerUpperBound
        let fractionLowerBound = Swift.max(_Precision.fractionLowerBound, number.fraction.count)
        let fraction = fractionLowerBound...fractionLowerBound
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
}

// MARK: - Implementations

@usableFromInline protocol PrecisionImplementation {

    // MARK: Requirements
            
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision
    
    @inlinable func capacity(number: Number) throws -> Capacity
}

// MARK: - SignificantPrecision

/// Evaluates significant digits.
@usableFromInline struct SignificantPrecision<Value: Precise>: PrecisionImplementation {

    // MARK: Properties
    
    @usableFromInline let significant: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(significant: R) where R.Bound == Int {
        self.significant = _Precision.clamped(significant, to: _Precision.significantLowerBound...Value.maxLosslessValueDigits)
    }
    
    // MARK: Styles
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(significant)
    }
    
    // MARK: Capacity
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        let integerCapacity = Value.maxLosslessUpperDigits - number.integer.count
        guard integerCapacity >= 0 else {
            throw _Precision.cancellation(excess: .integer)
        }
        
        let fractionCapacity = Value.maxLosslessLowerDigits - number.fraction.count
        guard fractionCapacity >= 0 else {
            throw _Precision.cancellation(excess: .fraction)
        }
        
        let significantCapacity = significant.upperBound - number.significantCount()
        guard significantCapacity >= 0 else {
            throw _Precision.cancellation(excess: .significant)
        }
        
        return .init(integer: integerCapacity, fraction: fractionCapacity, significant: significantCapacity)
    }
}

// MARK: - IntegerAndFractionPrecision

/// Evaluates integer and fraction digits.
@usableFromInline struct IntegerAndFractionPrecision<Value: Precise>: PrecisionImplementation {
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>

    // MARK: Properties
    
    @usableFromInline let integer: ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) where R0.Bound == Int, R1.Bound == Int {
        self.integer = _Precision.clamped(integer, to: _Precision.integerLowerBound...Value.maxLosslessUpperDigits)
        self.fraction = _Precision.clamped(fraction, to: _Precision.fractionLowerBound...Value.maxLosslessLowerDigits)
    }
    
    @inlinable init<R: RangeExpression>(integer: R) where R.Bound == Int {
        self.init(integer: integer, fraction: _Precision.fractionLowerBound...)
    }
    
    @inlinable init<R: RangeExpression>(fraction: R) where R.Bound == Int {
        self.init(integer: _Precision.integerLowerBound..., fraction: fraction)
    }
    
    // MARK: Styles

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    // MARK: Capacity
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        let integerCapacity = integer.upperBound - number.integer.count
        guard integerCapacity >= 0 else {
            throw _Precision.cancellation(excess: .integer)
        }
        
        let fractionCapacity = fraction.upperBound - number.fraction.count
        guard fractionCapacity >= 0 else {
            throw _Precision.cancellation(excess: .fraction)
        }
        
        let significantCapacity = Value.maxLosslessValueDigits - number.significantCount()
        guard significantCapacity >= 0 else {
            throw _Precision.cancellation(excess: .significant)
        }
        
        return .init(integer: integerCapacity, fraction: fractionCapacity, significant: significantCapacity)
    }
}

// MARK: - Helpers

@usableFromInline enum _Precision {
    
    // MARK: Defaults
    
    @usableFromInline static let significantLowerBound: Int = 1
    @usableFromInline static let     integerLowerBound: Int = 1
    @usableFromInline static let    fractionLowerBound: Int = 0
    
    // MARK: Errors
    
    @inlinable static func cancellation(excess component: Component) -> Cancellation {
        .init(reason: "Precision of \(component.rawValue) digits exceeded its capacity.")
    }
    
    // MARK: Bounds
    
    @inlinable static func clamped<R: RangeExpression>(_ expression: R, to limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range: Range<Int> = expression.relative(to: limits.lowerBound ..< limits.upperBound + 1)
        return Swift.max(limits.lowerBound, range.lowerBound) ... Swift.min(range.upperBound - 1, limits.upperBound)
    }
    
    // MARK: Components
    
    @usableFromInline enum Component: String {
        case significant
        case integer
        case fraction
    }
}

// MARK: - Instances: Significant

public extension Precision {

    // MARK: Digits
    
    @inlinable static func digits<R: RangeExpression>(_ significant: R) -> Self where R.Bound == Int {
        .init(implementation: Significant(significant: significant))
    }
    
    // MARK: Max
    
    @inlinable static func max(_ significant: Int) -> Self {
        digits(_Precision.significantLowerBound...significant)
    }
    
    // MARK: Named
            
    @inlinable static var standard: Self {
        .max(Value.maxLosslessValueDigits)
    }
}

// MARK: - Instances: IntegerAndFraction

public extension Precision where Value: PreciseFloatingPoint {
    
    // MARK: Digits

    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(implementation: IntegerAndFraction(integer: integer, fraction: fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(implementation: IntegerAndFraction(integer: integer, fraction: _Precision.fractionLowerBound...))
    }
    
    @inlinable static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(implementation: IntegerAndFraction(integer: _Precision.integerLowerBound..., fraction: fraction))
    }
    
    // MARK: Max
    
    @inlinable static func max(integer: Int, fraction: Int) -> Self  {
        .digits(integer: _Precision.integerLowerBound...integer, fraction: _Precision.fractionLowerBound...fraction)
    }
    
    @inlinable static func max(integer: Int) -> Self {
        .max(integer: integer, fraction: Value.maxLosslessValueDigits - integer)
    }
    
    @inlinable static func max(fraction: Int) -> Self {
        .max(integer: Value.maxLosslessValueDigits - fraction, fraction: fraction)
    }
}
