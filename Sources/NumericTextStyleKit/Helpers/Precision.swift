//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

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

public extension Precision where Value: Float {

    // MARK: Expressions
    
    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, decimal: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(strategy: Parts(upper: integer, lower: decimal))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(strategy: Parts(upper: integer, lower: Defaults.lowerLowerBound...))
    }
    
    @inlinable static func digits<R: RangeExpression>(decimal: R) -> Self where R.Bound == Int {
        .init(strategy: Parts(upper: Defaults.upperLowerBound..., lower: decimal))
    }
    
    // MARK: Subexpressions
    
    @inlinable static func max(integer: Int, decimal: Int) -> Self  {
        .digits(integer: Defaults.upperLowerBound...integer, decimal: Defaults.lowerLowerBound...decimal)
    }
    
    @inlinable static func max(integer: Int) -> Self {
        .max(integer: integer, decimal: Value.maxLosslessDigits - integer)
    }
    
    @inlinable static func max(decimal: Int) -> Self {
        .max(integer: Value.maxLosslessDigits - decimal, decimal: decimal)
    }
}

// MARK: - Interoperabilities

extension Precision {
    
    // MARK: Utilities
    
    @inlinable func displayableStyle() -> Formattable.Precision {
        strategy.displayableStyle()
    }
    
    @inlinable func editableValidationWithCapacity(digits: NumberOfDigits) -> NumberOfDigits? {
        strategy.editableValidationWithCapacity(digits: digits)
    }
    
    @inlinable func editableStyle() -> Formattable.Precision {
        let integer = Defaults.upperLowerBound...Value.maxLosslessIntegerDigits
        let decimal = Defaults.lowerLowerBound...Value.maxLosslessDecimalDigits
        
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: decimal)
    }
    
    @inlinable func editableStyle(_ digits: NumberOfDigits) -> Formattable.Precision {
        let upperUpperBound = Swift.max(Defaults.upperLowerBound, digits.upper)
        let lowerLowerBound = Swift.max(Defaults.lowerLowerBound, digits.lower)
                
        let upper = Defaults.upperLowerBound...upperUpperBound
        let lower =          lowerLowerBound...lowerLowerBound
        
        return .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
}

#warning("Everything below this line is a mess.")
// MARK: - Strategies

@usableFromInline protocol PrecisionStrategy {
    typealias Defaults = PrecisionDefaults
    
    @inlinable func displayableStyle() -> Formattable.Precision
        
    @inlinable func editableValidationWithCapacity(digits: NumberOfDigits) -> NumberOfDigits?
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

    @inlinable func displayableStyle() -> Formattable.Precision {
        .significantDigits(total)
    }
    
    @inlinable func editableValidationWithCapacity(digits: NumberOfDigits) -> NumberOfDigits? {
        let totalCapacity = total.upperBound - digits.upper - digits.lower
        guard totalCapacity >= 0 else { return nil }

        return NumberOfDigits(upper: totalCapacity, lower: totalCapacity)
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
    
    @inlinable func displayableStyle() -> Formattable.Precision {
        .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
    
    @inlinable func editableValidationWithCapacity(digits: NumberOfDigits) -> NumberOfDigits? {
        let totalCapacity = Value.maxLosslessDigits - digits.upper - digits.lower
        guard totalCapacity >= 0 else { return nil }
        
        let lowerCapacity = lower.upperBound - digits.lower
        guard lowerCapacity >= 0 else { return nil }
        
        let upperCapacity = upper.upperBound - digits.upper
        guard upperCapacity >= 0 else { return nil }
        
        return NumberOfDigits(upper: upperCapacity, lower: lowerCapacity)
    }
}

// MARK: - Defaults

@usableFromInline enum PrecisionDefaults {
    @usableFromInline static let totalLowerBound: Int = 1
    @usableFromInline static let upperLowerBound: Int = 1
    @usableFromInline static let lowerLowerBound: Int = 0
}

#endif
