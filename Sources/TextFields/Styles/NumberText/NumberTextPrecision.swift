//
//  NumberTextPrecision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import enum SwiftUI.NumberFormatStyleConfiguration

// MARK: - NumberTextPrecisionItem

public protocol NumberTextPrecisionItem {
    
    // MARK: Properties: Static
        
    static var maxTotalDigits: Int { get }
    static var maxUpperDigits: Int { get }
    static var maxLowerDigits: Int { get }
}

// MARK: - NumberTextPrecision

@available(iOS 15.0, *)
public struct NumberTextPrecision<Item: NumberTextPrecisionItem> {
    @usableFromInline typealias Defaults = NumberTextPrecisionDefaults
    @usableFromInline typealias Strategy = NumberTextPrecisionStrategy
    @usableFromInline typealias Total = NumberTextPrecisionTotal<Item>
    @usableFromInline typealias Parts = NumberTextPrecisionParts<Item>
    
    // MARK: Properties
    
    @usableFromInline let strategy: Strategy
    
    // MARK: Initializers
    
    @inlinable init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    // MARK: Initializers: Defaults
    
    @inlinable public static var max: Self {
        .max(Item.maxTotalDigits)
    }
        
    // MARK: Initializers: Total
    
    @inlinable public static func digits<R: RangeExpression>(_ total: R) -> Self where R.Bound == Int {
        .init(strategy: Total(total: total))
    }
    
    @inlinable public static func max(_ total: Int) -> Self {
        digits(Defaults.totalLowerBound...total)
    }
    
    // MARK: Initializers: Separate
    
    @inlinable public static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(strategy: Parts(upper: integer, lower: fraction))
    }
    
    @inlinable public static func max(integer: Int, fraction: Int) -> Self {
        .digits(integer: Defaults.upperLowerBound...integer, fraction: Defaults.lowerLowerBound...fraction)
    }
    
    @inlinable public static func max(integer: Int) -> Self {
        .max(integer: integer, fraction: Item.maxTotalDigits - integer)
    }
    
    @inlinable public static func max(fraction: Int) -> Self {
        .max(integer: Item.maxTotalDigits - fraction, fraction: fraction)
    }
}

// MARK: - Interoperabilities

@available(iOS 15.0, *)
extension NumberTextPrecision {
    
    // MARK: Utilities
    
    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision {
        strategy.displayableStyle()
    }
    
    #warning("numberOfIntegerDigits: components.integerDigits.count, numberOfFractionDigits: components.decimalDigits.count")
    @inlinable func editableStyle(integersLowerBound: Int? = nil, fractionLowerBound: Int? = nil) -> NumberFormatStyleConfiguration.Precision {
        let integersLimits = (integersLowerBound ?? Defaults.upperLowerBound) ... Item.maxUpperDigits
        let fractionLimits = (fractionLowerBound ?? Defaults.lowerLowerBound) ... Item.maxLowerDigits
        
        return .integerAndFractionLength(integerLimits: integersLimits, fractionLimits: fractionLimits)
    }

    @inlinable func validate(editable components: DecimalTextComponents) -> Bool {
        strategy.editableValidation(numberOfIntegerDigits: components.integerDigits.count, numberOfFractionDigits: components.decimalDigits.count)
    }
}

// MARK: - Strategies

@available(iOS 15.0, *)
@usableFromInline protocol NumberTextPrecisionStrategy {
    typealias Defaults = NumberTextPrecisionDefaults
    
    func displayableStyle() -> NumberFormatStyleConfiguration.Precision
        
    func editableValidation(numberOfIntegerDigits: Int, numberOfFractionDigits: Int) -> Bool
}

// MARK: - Strategies: Total

@available(iOS 15.0, *)
@usableFromInline struct NumberTextPrecisionTotal<Item: NumberTextPrecisionItem>: NumberTextPrecisionStrategy {

    // MARK: Properties
    
    @usableFromInline let total: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(total: R) where R.Bound == Int {
        self.total = Self.limits(total, max: Item.maxTotalDigits)
    }
    
    // MARK: Initializers: Helpers
    
    @inlinable static func limits<R: RangeExpression>(_ range: R, max: Int) -> ClosedRange<Int> where R.Bound == Int {
        ClosedRange(range.relative(to: 0 ..< max + 1))
    }
    
    // MARK: Utilities

    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(total)
    }
        
    @inlinable func editableValidation(numberOfIntegerDigits: Int, numberOfFractionDigits: Int) -> Bool {
        numberOfIntegerDigits + numberOfFractionDigits <= total.upperBound
    }
}

// MARK: - Strategies: Separate

@available(iOS 15.0, *)
@usableFromInline struct NumberTextPrecisionParts<Item: NumberTextPrecisionItem>: NumberTextPrecisionStrategy {

    // MARK: Properties
    
    @usableFromInline let upper: ClosedRange<Int>
    @usableFromInline let lower: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(upper: R0, lower: R1) where R0.Bound == Int, R1.Bound == Int {
        self.upper = Self.limits(upper, max: Item.maxUpperDigits)
        self.lower = Self.limits(lower, max: Item.maxLowerDigits)
        
        precondition(self.lower.lowerBound + self.upper.lowerBound <= Item.maxTotalDigits, "Max precision lowerBound: \(Item.maxTotalDigits).")
    }
    
    @inlinable init<R: RangeExpression>(upper: R) where R.Bound == Int {
        let upper = Self.limits(upper, max: Item.maxUpperDigits)
        
        self.init(upper: upper, lower: Defaults.lowerLowerBound...)
    }
    
    @inlinable init<R: RangeExpression>(lower: R) where R.Bound == Int {
        let lower = Self.limits(lower, max: Item.maxLowerDigits)
        
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
    
    @inlinable func editableValidation(numberOfIntegerDigits: Int, numberOfFractionDigits: Int) -> Bool {
        func validateTotal() -> Bool {
            numberOfIntegerDigits + numberOfFractionDigits <= Item.maxTotalDigits
        }
        
        func validateParts() -> Bool {
            numberOfIntegerDigits <= upper.upperBound && numberOfFractionDigits <= lower.upperBound
        }
        
        return validateTotal() && validateParts()
    }
}

// MARK: - NumberTextPrecisionDefaults

@usableFromInline enum NumberTextPrecisionDefaults {
    @usableFromInline static let totalLowerBound: Int = 1
    @usableFromInline static let upperLowerBound: Int = 1
    @usableFromInline static let lowerLowerBound: Int = 0
}
