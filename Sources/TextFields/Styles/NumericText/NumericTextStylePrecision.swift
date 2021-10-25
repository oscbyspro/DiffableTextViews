//
//  NumericTextPrecision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

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
    
    @inlinable func editableValidation(digits: NumberOfDigits) -> Bool {
        strategy.editableValidation(digits: digits)
    }
    
    @inlinable func editableStyle() -> NumberFormatStyleConfiguration.Precision {
        let integers = Defaults.upperLowerBound...Scheme.maxUpperDigits
        let fraction = Defaults.lowerLowerBound...Scheme.maxLowerDigits
        
        return .integerAndFractionLength(integerLimits: integers, fractionLimits: fraction)
    }
    
    @inlinable func editableStyle(_ digits: NumberOfDigits) -> NumberFormatStyleConfiguration.Precision {
        let upper = Defaults.upperLowerBound...(Swift.max(Defaults.upperLowerBound, digits.upper))
        let lower = Defaults.lowerLowerBound...(digits.lower)

        return .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
}

// MARK: - Strategies

@usableFromInline protocol NumericTextPrecisionStrategy {
    typealias Defaults = NumericTextPrecisionDefaults
    typealias NumberOfDigits = NumericTextNumberOfDigits
    
    
    func displayableStyle() -> NumberFormatStyleConfiguration.Precision
        
    func editableValidation(digits: NumberOfDigits) -> Bool
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
        
    @inlinable func editableValidation(digits: NumberOfDigits) -> Bool {
        digits.upper + digits.lower <= total.upperBound
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
    
    @inlinable func editableValidation(digits: NumberOfDigits) -> Bool {
        func validateTotal() -> Bool {
            digits.upper + digits.lower <= Scheme.maxTotalDigits
        }
        
        func validateParts() -> Bool {
            digits.upper <= upper.upperBound && digits.lower <= lower.upperBound
        }
        
        return validateTotal() && validateParts()
    }
}

// MARK: - NumericTextPrecisionDefaults

@usableFromInline enum NumericTextPrecisionDefaults {
    @usableFromInline static let totalLowerBound: Int = 1
    @usableFromInline static let upperLowerBound: Int = 1
    @usableFromInline static let lowerLowerBound: Int = 0
}
