//
//  NumberTextPrecision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import enum SwiftUI.NumberFormatStyleConfiguration

#warning("WIP")

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
    @usableFromInline typealias Strategy = NumberTextPrecisionStrategy
    @usableFromInline typealias Total = NumberTextPrecisionTotal<Item>
    @usableFromInline typealias Separate = NumberTextPrecisionSeparate<Item>
    
    // MARK: Properties
    
    @usableFromInline let strategy: Strategy
    
    // MARK: Initializers
    
    @inlinable init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    // MARK: Initializers: Default
    
    @inlinable public static var max: Self {
        .max(digits: Item.maxTotalDigits)
    }
    
    // MARK: Initializers: Total
    

    @inlinable public static func digits<R: RangeExpression>(_ digits: R) -> Self where R.Bound == Int {
        .init(strategy: Total(significands: digits))
    }
    
    @inlinable public static func max(digits: Int) -> Self {
        .init(strategy: Total(significands: 1...digits))
    }
    
    // MARK: Initializers: Separate
    
    @inlinable public static func digits<R0: RangeExpression, R1: RangeExpression>(integerLimits: R0, fractionLimits: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(strategy: Separate(upper: integerLimits, lower: fractionLimits))
    }
    
    @inlinable public static func digits<R: RangeExpression>(integerLimits: R) -> Self where R.Bound == Int {
        .init(strategy: Separate(upper: integerLimits))
    }
    
    @inlinable public static func digits<R: RangeExpression>(fractionLimits: R) -> Self where R.Bound == Int {
        .init(strategy: Separate(lower: fractionLimits))
    }
    
    @inlinable public static func max(integerDigits: Int, fractionDigits: Int) -> Self {
        .digits(integerLimits: 1 ... integerDigits, fractionLimits: 0 ... fractionDigits)
    }
    
    @inlinable public static func max(integerDigits: Int) -> Self {
        .digits(integerLimits: 1 ... integerDigits)
    }
    
    @inlinable public static func max(fractionDigits: Int) -> Self {
        .digits(fractionLimits: 0 ... fractionDigits)
    }
}

// MARK: - Interoperabilities

@available(iOS 15.0, *)
extension NumberTextPrecision {
    
    // MARK: Utilities
    
    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision {
        strategy.displayableStyle()
    }
    
    @inlinable func editableStyle(integersLowerBound: Int? = nil, decimalsLowerBound: Int? = nil) -> NumberFormatStyleConfiguration.Precision {
        let integerLimits = (integersLowerBound ?? 1) ... Item.maxUpperDigits
        let decimalLimits = (decimalsLowerBound ?? 0) ... Item.maxLowerDigits

        return .integerAndFractionLength(integerLimits: integerLimits, fractionLimits: decimalLimits)
    }

    @inlinable func validate(editable components: DecimalTextComponents) -> Bool {
        strategy.editableValidation(numberOfIntegerDigits: components.integerDigits.count, numberOfFractionDigits: components.decimalDigits.count)
    }
}

// MARK: - Strategies

@available(iOS 15.0, *)
@usableFromInline protocol NumberTextPrecisionStrategy {
    
    func displayableStyle() -> NumberFormatStyleConfiguration.Precision
        
    func editableValidation(numberOfIntegerDigits: Int, numberOfFractionDigits: Int) -> Bool
}

// MARK: - Strategies: Total

@available(iOS 15.0, *)
@usableFromInline struct NumberTextPrecisionTotal<Item: NumberTextPrecisionItem>: NumberTextPrecisionStrategy {
    
    // MARK: Properties
    
    @usableFromInline let significands: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(significands: R) where R.Bound == Int {
        self.significands = Self.limits(significands, max: Item.maxTotalDigits)
    }
    
    // MARK: Strategy
    
    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(significands)
    }
        
    @inlinable func editableValidation(numberOfIntegerDigits: Int, numberOfFractionDigits: Int) -> Bool {
        numberOfIntegerDigits + numberOfFractionDigits <= significands.upperBound
    }
    
    // MARK: Initializers: Helpers
    
    @inlinable static func limits<R: RangeExpression>(_ range: R, max: Int) -> ClosedRange<Int> where R.Bound == Int {
        ClosedRange(range.relative(to: 0 ..< max + 1))
    }
}

// MARK: - Strategies: Separate

@available(iOS 15.0, *)
@usableFromInline struct NumberTextPrecisionSeparate<Item: NumberTextPrecisionItem>: NumberTextPrecisionStrategy {
    
    // MARK: Properties
    
    @usableFromInline let upper: ClosedRange<Int>
    @usableFromInline let lower: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(upper: R0, lower: R1) where R0.Bound == Int, R1.Bound == Int {
        self.upper = Self.limits(upper, max: Item.maxUpperDigits)
        self.lower = Self.limits(lower, max: Item.maxLowerDigits)
                
        precondition(self.lower.upperBound + self.lower.upperBound <= Item.maxTotalDigits)
    }
    
    @inlinable init<R: RangeExpression>(upper: R) where R.Bound == Int {
        let upper = Self.limits(upper, max: Item.maxUpperDigits)
        
        self.init(upper: upper, lower: 0 ... (Item.maxTotalDigits - upper.upperBound))
    }
    
    @inlinable init<R: RangeExpression>(lower: R) where R.Bound == Int {
        let lower = Self.limits(lower, max: Item.maxLowerDigits)
        
        self.init(upper: 1 ... (Item.maxTotalDigits - lower.upperBound), lower: lower)
    }
    
    // MARK: Protocol: Strategy
    
    @inlinable func displayableStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
    
    @inlinable func editableValidation(numberOfIntegerDigits: Int, numberOfFractionDigits: Int) -> Bool {
        numberOfIntegerDigits <= upper.upperBound && numberOfFractionDigits <= lower.upperBound
    }
    
    // MARK: Initializers: Helpers
    
    @inlinable static func limits<R: RangeExpression>(_ range: R, max: Int) -> ClosedRange<Int> where R.Bound == Int {
        ClosedRange(range.relative(to: 0 ..< max + 1))
    }
}
