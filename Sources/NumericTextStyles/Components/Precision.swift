//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import enum Foundation.NumberFormatStyleConfiguration

// MARK: - Precision

/// - Note: Lower precision bounds are enforced only when the view is idle.
public struct Precision<Value: Precise> {
    @usableFromInline typealias Total = PrecisionTotal<Value>
    @usableFromInline typealias Parts = PrecisionParts<Value>
    
    // MARK: Properties
    
    @usableFromInline let implementation: PrecisionImplementation
    
    // MARK: Initializers
    
    @inlinable init(implementation: PrecisionImplementation) {
        self.implementation = implementation
    }
    
    // MARK: Showcase: Styles

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        implementation.showcaseStyle()
    }
    
    // MARK: Editable: Styles
    
    @inlinable func editableStyle() -> NumberFormatStyleConfiguration.Precision {
        let integer = _Precision.defaultIntegerLowerBound...Value.maxLosslessIntegerDigits
        let fraction = _Precision.defaultFractionLowerBound...Value.maxLosslessFractionDigits
        
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    @inlinable func editableStyle(count: Count) -> NumberFormatStyleConfiguration.Precision {
        let integerUpperBound = Swift.max(_Precision.defaultIntegerLowerBound, count.integer)
        let integer = _Precision.defaultIntegerLowerBound...integerUpperBound
        
        let fractionLowerBound = Swift.max(_Precision.defaultFractionLowerBound, count.fraction)
        let fraction = fractionLowerBound...fractionLowerBound
        
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    // MARK: Editable: Validation
    
    @inlinable func editableValidationThatGeneratesCapacity(count: Count) -> Count? {
        implementation.editableValidationThatGeneratesCapacity(count: count)
    }
}

// MARK: - Precision: Total

public extension Precision {

    // MARK: Digits
    
    @inlinable static func digits<R: RangeExpression>(_ total: R) -> Self where R.Bound == Int {
        .init(implementation: Total(total: total))
    }
    
    // MARK: Max
    
    @inlinable static func max(_ total: Int) -> Self {
        digits(_Precision.defaultTotalLowerBound...total)
    }
    
    // MARK: Max: Standard
        
    @inlinable static var max: Self {
        .max(Value.maxLosslessTotalDigits)
    }
}

// MARK: - Precision: Parts

public extension Precision where Value: PreciseFloatingPoint {

    // MARK: Digits
    
    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(implementation: Parts(integer: integer, fraction: fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(implementation: Parts(integer: integer, fraction: _Precision.defaultFractionLowerBound...))
    }
    
    @inlinable static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(implementation: Parts(integer: _Precision.defaultIntegerLowerBound..., fraction: fraction))
    }
    
    // MARK: Max
    
    @inlinable static func max(integer: Int, fraction: Int) -> Self  {
        .digits(integer: _Precision.defaultIntegerLowerBound...integer, fraction: _Precision.defaultFractionLowerBound...fraction)
    }
    
    @inlinable static func max(integer: Int) -> Self {
        .max(integer: integer, fraction: Value.maxLosslessTotalDigits - integer)
    }
    
    @inlinable static func max(fraction: Int) -> Self {
        .max(integer: Value.maxLosslessTotalDigits - fraction, fraction: fraction)
    }
}

// MARK: - Implementations

@usableFromInline protocol PrecisionImplementation {
    typealias Defaults = _Precision
    
    // MARK: Requirements
        
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision
        
    @inlinable func editableValidationThatGeneratesCapacity(count: Count) -> Count?
}

// MARK: - Implementations: Total

@usableFromInline struct PrecisionTotal<Value: Precise>: PrecisionImplementation {

    // MARK: Properties
    
    @usableFromInline let total: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(total: R) where R.Bound == Int {
        self.total = ClosedRange(total.relative(to: 0 ..< Value.maxLosslessTotalDigits + 1))
        
        precondition(self.total.upperBound <= Value.maxLosslessTotalDigits, "Precision: max \(Value.maxLosslessTotalDigits).")
    }
    
    // MARK: Utilities
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(total)
    }
    
    @inlinable func editableValidationThatGeneratesCapacity(count: Count) -> Count? {
        let capacity = total.upperBound - count.total
        guard capacity >= 0 else { return nil }

        return .init(integer: capacity, fraction: capacity)
    }
}

// MARK: - Implementations: Parts

@usableFromInline struct PrecisionParts<Value: Precise>: PrecisionImplementation {

    // MARK: Properties
    
    @usableFromInline let integer:  ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) where R0.Bound == Int, R1.Bound == Int {
        self.integer = ClosedRange(integer.relative(to: 0 ..< Value.maxLosslessIntegerDigits + 1))
        self.fraction = ClosedRange(fraction.relative(to: 0 ..< Value.maxLosslessFractionDigits + 1))

        let total = self.integer.lowerBound + self.fraction.lowerBound
        precondition(total <= Value.maxLosslessTotalDigits, "Precision: max \(Value.maxLosslessTotalDigits).")
    }
    
    @inlinable init<R: RangeExpression>(integer: R) where R.Bound == Int {
        self.init(integer: integer, fraction: Defaults.defaultFractionLowerBound...)
    }
    
    @inlinable init<R: RangeExpression>(fraction: R) where R.Bound == Int {
        self.init(integer: Defaults.defaultIntegerLowerBound..., fraction: fraction)
    }
    
    // MARK: Utilities
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    @inlinable func editableValidationThatGeneratesCapacity(count: Count) -> Count? {
        let totalCapacity = Value.maxLosslessTotalDigits - count.total
        guard totalCapacity >= 0 else { return nil }
        
        let integerCapacity = integer.upperBound - count.integer
        guard integerCapacity >= 0 else { return nil }
        
        let fractionCapacity = fraction.upperBound - count.fraction
        guard fractionCapacity >= 0 else { return nil }
        
        return .init(integer: integerCapacity, fraction: fractionCapacity)
    }
}

// MARK: - Precision: Helpers

@usableFromInline enum _Precision {
    
    // MARK: Defaults
    
    @usableFromInline static let defaultTotalLowerBound: Int = 1
    @usableFromInline static let defaultIntegerLowerBound: Int = 1
    @usableFromInline static let defaultFractionLowerBound: Int = 0
}
