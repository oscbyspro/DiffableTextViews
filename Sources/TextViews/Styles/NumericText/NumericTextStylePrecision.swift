//
//  NumericTextPrecision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

import enum Foundation.NumberFormatStyleConfiguration

// MARK: - NumericTextPrecision

public struct NumericTextStylePrecision<Scheme: NumericTextScheme> {
    @usableFromInline typealias Strategy = NumericTextPrecisionStrategy
    @usableFromInline typealias Defaults = NumericTextPrecisionDefaults
    @usableFromInline typealias Total = NumericTextPrecisionTotal<Scheme>
    @usableFromInline typealias Parts = NumberTextPrecisionParts<Scheme>
    @usableFromInline typealias NumberOfDigits = NumericTextNumberOfDigits
    
    // MARK: Properties
    
    @usableFromInline let strategy: Strategy
    
    // MARK: Initializers
    
    @inlinable init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    // MARK: Initializers: Named
    
    @inlinable public static var max: Self {
        .max(Scheme.maxTotalDigits)
    }
        
    // MARK: Initializers: Total
    
    @inlinable public static func digits<R: RangeExpression>(_ total: R) -> Self where R.Bound == Int {
        .init(strategy: Total(total: total))
    }
    
    @inlinable public static func max(_ total: Int) -> Self {
        digits(Defaults.totalLowerBound...total)
    }
}

extension NumericTextStylePrecision where Scheme: NumericTextFloatScheme {

    // MARK: Initializers: Parts
    
    @inlinable public static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(strategy: Parts(upper: integer, lower: fraction))
    }
    
    @inlinable public static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(strategy: Parts(upper: integer, lower: Defaults.lowerLowerBound...))
    }
    
    @inlinable public static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(strategy: Parts(upper: Defaults.upperLowerBound..., lower: fraction))
    }
    
    @inlinable public static func max(integer: Int, fraction: Int) -> Self  {
        .digits(integer: Defaults.upperLowerBound...integer, fraction: Defaults.lowerLowerBound...fraction)
    }
    
    @inlinable public static func max(integer: Int) -> Self {
        .max(integer: integer, fraction: Scheme.maxTotalDigits - integer)
    }
    
    @inlinable public static func max(fraction: Int) -> Self {
        .max(integer: Scheme.maxTotalDigits - fraction, fraction: fraction)
    }
}

// MARK: - Interoperabilities

extension NumericTextStylePrecision {
    
    // MARK: Utilities
    
    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision {
        strategy.displayableStyle()
    }
    
    @inlinable func editableValidationWithCapacity(digits: NumberOfDigits) -> NumberOfDigits? {
        strategy.editableValidationWithCapacity(digits: digits)
    }
    
    @inlinable func editableStyle() -> NumberFormatStyleConfiguration.Precision {
        let integers = Defaults.upperLowerBound...Scheme.maxUpperDigits
        let fraction = Defaults.lowerLowerBound...Scheme.maxLowerDigits
        
        return .integerAndFractionLength(integerLimits: integers, fractionLimits: fraction)
    }
    
    @inlinable func editableStyle(_ digits: NumberOfDigits) -> NumberFormatStyleConfiguration.Precision {
        let upperUpperBound = Swift.max(Defaults.upperLowerBound, digits.upper)
        let lowerLowerBound = Swift.max(Defaults.lowerLowerBound, digits.lower)
                
        let upper = Defaults.upperLowerBound...upperUpperBound
        let lower =          lowerLowerBound...lowerLowerBound
        
        return .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
}

// MARK: - Strategies

@usableFromInline protocol NumericTextPrecisionStrategy {
    typealias Defaults = NumericTextPrecisionDefaults
    typealias NumberOfDigits = NumericTextNumberOfDigits
    
    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision
        
    @inlinable func editableValidationWithCapacity(digits: NumberOfDigits) -> NumberOfDigits?
}

// MARK: - Strategies: Total

@usableFromInline struct NumericTextPrecisionTotal<Scheme: NumericTextScheme>: NumericTextPrecisionStrategy {

    // MARK: Properties
    
    @usableFromInline let total: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(total: R) where R.Bound == Int {
        self.total = Self.limits(total, max: Scheme.maxTotalDigits)
    }
    
    // MARK: Initializers: Helpers
    
    @inlinable static func limits<R: RangeExpression>(_ range: R, max: Int) -> ClosedRange<Int> where R.Bound == Int {
        ClosedRange(range.relative(to: 0 ..< max + 1))
    }
    
    // MARK: Utilities

    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(total)
    }
        

    @inlinable func editableValidationWithCapacity(digits: NumberOfDigits) -> NumberOfDigits? {
        let totalCapacity = total.upperBound - digits.upper - digits.lower
        guard totalCapacity >= 0 else { return nil }

        return NumberOfDigits(upper: totalCapacity, lower: totalCapacity)
    }
}

// MARK: - Strategies: Separate

@usableFromInline struct NumberTextPrecisionParts<Scheme: NumericTextScheme>: NumericTextPrecisionStrategy {

    // MARK: Properties
    
    @usableFromInline let upper: ClosedRange<Int>
    @usableFromInline let lower: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(upper: R0, lower: R1) where R0.Bound == Int, R1.Bound == Int {
        self.upper = Self.limits(upper, max: Scheme.maxUpperDigits)
        self.lower = Self.limits(lower, max: Scheme.maxLowerDigits)
        
        precondition(self.lower.lowerBound + self.upper.lowerBound <= Scheme.maxTotalDigits, "Max precision: \(Scheme.maxTotalDigits).")
    }
    
    @inlinable init<R: RangeExpression>(upper: R) where R.Bound == Int {
        let upper = Self.limits(upper, max: Scheme.maxUpperDigits)
        
        self.init(upper: upper, lower: Defaults.lowerLowerBound...)
    }
    
    @inlinable init<R: RangeExpression>(lower: R) where R.Bound == Int {
        let lower = Self.limits(lower, max: Scheme.maxLowerDigits)
        
        self.init(upper: Defaults.upperLowerBound..., lower: lower)
    }
    
    // MARK: Initializers: Helpers
    
    @inlinable static func limits<R: RangeExpression>(_ range: R, max: Int) -> ClosedRange<Int> where R.Bound == Int {
        ClosedRange(range.relative(to: 0 ..< max + 1))
    }
    
    // MARK: Utilities
    
    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
    
    @inlinable func editableValidationWithCapacity(digits: NumberOfDigits) -> NumberOfDigits? {
        let totalCapacity = Scheme.maxTotalDigits - digits.upper - digits.lower
        guard totalCapacity >= 0 else { return nil }
        
        let lowerCapacity = lower.upperBound - digits.lower
        guard lowerCapacity >= 0 else { return nil }
        
        let upperCapacity = upper.upperBound - digits.upper
        guard upperCapacity >= 0 else { return nil }
        
        return NumberOfDigits(upper: lowerCapacity, lower: upperCapacity)
    }
}

// MARK: - NumericTextPrecisionDefaults

@usableFromInline enum NumericTextPrecisionDefaults {
    @usableFromInline static let totalLowerBound: Int = 1
    @usableFromInline static let upperLowerBound: Int = 1
    @usableFromInline static let lowerLowerBound: Int = 0
}

#endif
