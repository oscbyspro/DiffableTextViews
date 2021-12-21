//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import enum Foundation.NumberFormatStyleConfiguration

// MARK: - Precision

public struct Precision<Value: Precise> {
    @usableFromInline typealias Strategy = PrecisionStrategy
    @usableFromInline typealias Defaults = PrecisionDefaults
    @usableFromInline typealias Total = PrecisionTotal<Value>
    @usableFromInline typealias Parts = PrecisionParts<Value>
    
    // MARK: Properties
    
    @usableFromInline let strategy: Strategy
    
    // MARK: Initializers
    
    @inlinable init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    // MARK: Utilities: Showcase

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        strategy.showcaseStyle()
    }
    
    // MARK: Utilities: Editable
    
    @inlinable func editableStyle() -> NumberFormatStyleConfiguration.Precision {
        let integer  = Defaults.upperLowerBound...Value.maxLosslessIntegerDigits
        let fraction = Defaults.lowerLowerBound...Value.maxLosslessDecimalDigits
        
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    @inlinable func editableStyle(_ digits: _Count) -> NumberFormatStyleConfiguration.Precision {
        let upperUpperBound = Swift.max(Defaults.upperLowerBound, digits.integer)
        let lowerLowerBound = Swift.max(Defaults.lowerLowerBound, digits.fraction)
                
        let upper = Defaults.upperLowerBound...upperUpperBound
        let lower =          lowerLowerBound...lowerLowerBound
        
        return .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
    
    @inlinable func editableValidationWithCapacity(digits: _Count) -> _Count? {
        strategy.editableValidationWithCapacity(digits: digits)
    }
}

// MARK: - Initializers: Total

public extension Precision {
    
    // MARK: Special
    
    @inlinable static var max: Self {
        .max(Value.maxLosslessDigits)
    }
    
    // MARK: Expressions
    
    @inlinable static func digits<R: RangeExpression>(_ total: R) -> Self where R.Bound == Int {
        .init(strategy: Total(total: total))
    }
    
    // MARK: Subexpressions
    
    @inlinable static func max(_ total: Int) -> Self {
        digits(Defaults.totalLowerBound...total)
    }
}

// MARK: - Initializers: Parts

public extension Precision where Value: PreciseFloat {

    // MARK: Expressions
    
    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(strategy: Parts(upper: integer, lower: fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(strategy: Parts(upper: integer, lower: Defaults.lowerLowerBound...))
    }
    
    @inlinable static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(strategy: Parts(upper: Defaults.upperLowerBound..., lower: fraction))
    }
    
    // MARK: Subexpressions
    
    @inlinable static func max(integer: Int, fraction: Int) -> Self  {
        .digits(integer: Defaults.upperLowerBound...integer, fraction: Defaults.lowerLowerBound...fraction)
    }
    
    @inlinable static func max(integer: Int) -> Self {
        .max(integer: integer, fraction: Value.maxLosslessDigits - integer)
    }
    
    @inlinable static func max(fraction: Int) -> Self {
        .max(integer: Value.maxLosslessDigits - fraction, fraction: fraction)
    }
}

// MARK: - Strategies

@usableFromInline protocol PrecisionStrategy {
    typealias Defaults = PrecisionDefaults
    
    // MARK: Requirements
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision
        
    @inlinable func editableValidationWithCapacity(digits: _Count) -> _Count?
}

// MARK: - Strategies: Total

@usableFromInline struct PrecisionTotal<Value: Precise>: PrecisionStrategy {

    // MARK: Properties
    
    @usableFromInline let total: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(total: R) where R.Bound == Int {
        self.total = Self.limits(total, maxLosslessValue: Value.maxLosslessDigits)

        precondition(self.total.upperBound <= Value.maxLosslessDigits, "Max precision: \(Value.maxLosslessDigits).")
    }
    
    // MARK: Initializers: Helpers
    
    @inlinable static func limits<R: RangeExpression>(_ range: R, maxLosslessValue: Int) -> ClosedRange<Int> where R.Bound == Int {
        ClosedRange(range.relative(to: 0 ..< maxLosslessValue + 1))
    }
    
    // MARK: Utilities
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(total)
    }
    
    @inlinable func editableValidationWithCapacity(digits: _Count) -> _Count? {
        let totalCapacity = total.upperBound - digits.integer - digits.fraction
        guard totalCapacity >= 0 else { return nil }

        return _Count(integer: totalCapacity, fraction: totalCapacity)
    }
}

// MARK: - Strategies: Separate

@usableFromInline struct PrecisionParts<Value: Precise>: PrecisionStrategy {

    // MARK: Properties
    
    @usableFromInline let upper: ClosedRange<Int>
    @usableFromInline let lower: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(upper: R0, lower: R1) where R0.Bound == Int, R1.Bound == Int {
        self.upper = Self.limits(upper, maxLosslessValue: Value.maxLosslessIntegerDigits)
        self.lower = Self.limits(lower, maxLosslessValue: Value.maxLosslessDecimalDigits)
        
        precondition(self.lower.lowerBound + self.upper.lowerBound <= Value.maxLosslessDigits, "Max precision: \(Value.maxLosslessDigits).")
    }
    
    @inlinable init<R: RangeExpression>(upper: R) where R.Bound == Int {
        let upper = Self.limits(upper, maxLosslessValue: Value.maxLosslessIntegerDigits)
        
        self.init(upper: upper, lower: Defaults.lowerLowerBound...)
    }
    
    @inlinable init<R: RangeExpression>(lower: R) where R.Bound == Int {
        let lower = Self.limits(lower, maxLosslessValue: Value.maxLosslessDecimalDigits)
        
        self.init(upper: Defaults.upperLowerBound..., lower: lower)
    }
    
    // MARK: Initializers: Helpers
    
    @inlinable static func limits<R: RangeExpression>(_ range: R, maxLosslessValue: Int) -> ClosedRange<Int> where R.Bound == Int {
        ClosedRange(range.relative(to: 0 ..< maxLosslessValue + 1))
    }
    
    // MARK: Utilities
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
    
    @inlinable func editableValidationWithCapacity(digits: _Count) -> _Count? {
        let totalCapacity = Value.maxLosslessDigits - digits.integer - digits.fraction
        guard totalCapacity >= 0 else { return nil }
        
        let lowerCapacity = lower.upperBound - digits.fraction
        guard lowerCapacity >= 0 else { return nil }
        
        let upperCapacity = upper.upperBound - digits.integer
        guard upperCapacity >= 0 else { return nil }
        
        return _Count(integer: upperCapacity, fraction: lowerCapacity)
    }
}

// MARK: - Defaults

@usableFromInline enum PrecisionDefaults {
    @usableFromInline static let totalLowerBound: Int = 1
    @usableFromInline static let upperLowerBound: Int = 1
    @usableFromInline static let lowerLowerBound: Int = 0
}
