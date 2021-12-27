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
    @usableFromInline typealias ValueDigits = ValueDigitsPrecision<Value>
    @usableFromInline typealias PartsDigits = PartsDigitsPrecision<Value>

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
        let upper = _Precision.defaultUpperLowerBound...Value.maxLosslessUpperDigits
        let lower = _Precision.defaultLowerLowerBound...Value.maxLosslessLowerDigits
        
        return .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> NumberFormatStyleConfiguration.Precision {
        let upperUpperBound = Swift.max(_Precision.defaultUpperLowerBound, number.upper.count)
        let upper = _Precision.defaultUpperLowerBound...upperUpperBound
        
        let lowerLowerBound = Swift.max(_Precision.defaultLowerLowerBound, number.lower.count)
        let lower = lowerLowerBound...lowerLowerBound
        
        return .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
}

// MARK: - Implementations

@usableFromInline protocol PrecisionImplementation {

    // MARK: Requirements
            
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision
    
    @inlinable func capacity(number: Number) throws -> Capacity
}

// MARK: - Implementations: Value

/// Evaluates significant digits.
@usableFromInline struct ValueDigitsPrecision<Value: Precise>: PrecisionImplementation {

    // MARK: Properties
    
    @usableFromInline let value: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(value: R) where R.Bound == Int {
        self.value = _Precision.clamped(value, to: _Precision.defaultValueLowerBound...Value.maxLosslessValueDigits)
    }
    
    // MARK: Styles
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(value)
    }
    
    // MARK: Capacity
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        let upperCapacity = Value.maxLosslessUpperDigits - number.upper.count
        guard upperCapacity >= 0 else {
            throw _Precision.cancellation(excess: .upper)
        }
        
        let lowerCapacity = Value.maxLosslessLowerDigits - number.lower.count
        guard lowerCapacity >= 0 else {
            throw _Precision.cancellation(excess: .lower)
        }
        
        let valueCapacity = value.upperBound - number.valueCount()
        guard valueCapacity >= 0 else {
            throw _Precision.cancellation(excess: .value)
        }
        
        #warning("...")
        print(value.upperBound, number.valueCount())
        
        return .init(value: valueCapacity, upper: valueCapacity, lower: valueCapacity)
    }
}

// MARK: - Implementations: Parts

/// Evaluates upper and lower digits.
@usableFromInline struct PartsDigitsPrecision<Value: Precise>: PrecisionImplementation {
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>

    // MARK: Properties
    
    @usableFromInline let upper: ClosedRange<Int>
    @usableFromInline let lower: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(upper: R0, lower: R1) where R0.Bound == Int, R1.Bound == Int {
        self.upper = _Precision.clamped(upper, to: _Precision.defaultUpperLowerBound...Value.maxLosslessUpperDigits)
        self.lower = _Precision.clamped(lower, to: _Precision.defaultLowerLowerBound...Value.maxLosslessLowerDigits)
    }
    
    @inlinable init<R: RangeExpression>(upper: R) where R.Bound == Int {
        self.init(upper: upper, lower: _Precision.defaultLowerLowerBound...)
    }
    
    @inlinable init<R: RangeExpression>(lower: R) where R.Bound == Int {
        self.init(upper: _Precision.defaultUpperLowerBound..., lower: lower)
    }
    
    // MARK: Styles

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
    
    // MARK: Capacity
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        let upperCapacity = upper.upperBound - number.upper.count
        guard upperCapacity >= 0 else {
            throw _Precision.cancellation(excess: .upper)
        }
        
        let lowerCapacity = lower.upperBound - number.lower.count
        guard lowerCapacity >= 0 else {
            throw _Precision.cancellation(excess: .lower)
        }
        
        let valueCapacity = Value.maxLosslessValueDigits - number.valueCount()
        guard valueCapacity >= 0 else {
            throw _Precision.cancellation(excess: .value)
        }
        
        return .init(value: valueCapacity, upper: upperCapacity, lower: lowerCapacity)
    }
}

// MARK: - Helpers

@usableFromInline enum _Precision {
    
    // MARK: Defaults
    
    @usableFromInline static let defaultValueLowerBound: Int = 1
    @usableFromInline static let defaultUpperLowerBound: Int = 1
    @usableFromInline static let defaultLowerLowerBound: Int = 0
    
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
        case value
        case upper
        case lower
    }
}

// MARK: - Instances: Value

public extension Precision {

    // MARK: Digits
    
    @inlinable static func digits<R: RangeExpression>(_ significands: R) -> Self where R.Bound == Int {
        .init(implementation: ValueDigits(value: significands))
    }
    
    // MARK: Max
    
    @inlinable static func max(_ significands: Int) -> Self {
        digits(_Precision.defaultValueLowerBound...significands)
    }
    
    // MARK: Named
            
    @inlinable static var standard: Self {
        .max(Value.maxLosslessValueDigits)
    }
}

// MARK: - Instances: Parts

public extension Precision where Value: PreciseFloatingPoint {
    
    // MARK: Digits

    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(implementation: PartsDigits(upper: integer, lower: fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(implementation: PartsDigits(upper: integer, lower: _Precision.defaultLowerLowerBound...))
    }
    
    @inlinable static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(implementation: PartsDigits(upper: _Precision.defaultUpperLowerBound..., lower: fraction))
    }
    
    // MARK: Max
    
    @inlinable static func max(integer: Int, fraction: Int) -> Self  {
        .digits(integer: _Precision.defaultUpperLowerBound...integer, fraction: _Precision.defaultLowerLowerBound...fraction)
    }
    
    @inlinable static func max(integer: Int) -> Self {
        .max(integer: integer, fraction: Value.maxLosslessValueDigits - integer)
    }
    
    @inlinable static func max(fraction: Int) -> Self {
        .max(integer: Value.maxLosslessValueDigits - fraction, fraction: fraction)
    }
}
