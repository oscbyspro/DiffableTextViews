//
//  DecimalTextPrecision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-17.
//

import struct Foundation.Decimal

// MARK: - DecimalTextPrecision

@available(iOS 15.0, *)
public struct DecimalTextPrecision  {
    @usableFromInline typealias This = Self
    @usableFromInline typealias Strategy = DecimalTextPrecisionStrategy
    
    // MARK: Properties: Static
    
    public static let max = 38
    
    // MARK: Properties
    
    @usableFromInline let strategy: Strategy
    
    // MARK: Initializers
    
    @inlinable init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    // MARK: Initializers: Defaults
    
    @inlinable public static var defaults: Self {
        .init(strategy: DecimalTextPrecisionTotal(1 ... max))
    }
    
    // MARK: Initializers: Static

    @inlinable public static func digits(_ limits: ClosedRange<Int>) -> Self {
        precondition(limits.upperBound < max)
        
        return .init(strategy: DecimalTextPrecisionTotal(limits))
    }
        
    @inlinable public static func digits(integers: ClosedRange<Int>, decimals: ClosedRange<Int>) -> Self {
        precondition(integers.upperBound + decimals.upperBound <= max)
        
        return .init(strategy: DecimalTextPrecisionSeparate(integers: integers, decimals: decimals))
    }
    
    @inlinable public static func digits(integers: ClosedRange<Int>) -> Self {
        digits(integers: integers, decimals: 0 ... (max - integers.upperBound))
    }
    
    @inlinable public static func digits(decimals: ClosedRange<Int>) -> Self {
        digits(integers:  1 ... (max - decimals.upperBound), decimals: decimals)
    }
}

// MARK: - Interoperabilities

@available(iOS 15.0, *)
extension DecimalTextPrecision {
    
    // MARK: Utilities
    
    @inlinable func displayableStyle() -> Decimal.FormatStyle.Configuration.Precision {
        strategy.displayableStyle()
    }
    
    @inlinable func editableStyle(decimal: Bool = false) -> Decimal.FormatStyle.Configuration.Precision {
        strategy.editableStyle(decimal: decimal)
    }
    
    @inlinable func validate(editable components: DecimalTextComponents) -> Bool {
        strategy.editableValidation(numberOfIntegers: components.integerDigits.count, numberOfDecimals: components.decimalDigits.count)
    }
}

// MARK: - Strategies

@available(iOS 15.0, *)
@usableFromInline protocol DecimalTextPrecisionStrategy {
    typealias Style = Decimal.FormatStyle.Configuration.Precision
    
    func displayableStyle() -> Style
    
    func editableStyle(decimal: Bool) -> Style
    
    func editableValidation(numberOfIntegers: Int, numberOfDecimals: Int) -> Bool
}

// MARK: - Strategies: Total

@usableFromInline struct DecimalTextPrecisionTotal: DecimalTextPrecisionStrategy {
    
    // MARK: Properties
    
    @usableFromInline let limits: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init(_ limits: ClosedRange<Int>) {
        self.limits = limits
    }
    
    // MARK: Strategy
    
    @inlinable func displayableStyle() -> Style {
        .significantDigits(limits)
    }
    
    @inlinable func editableStyle(decimal: Bool) -> Style {
        let min = (decimal && limits.lowerBound > 0) ? 1 : 0
        return .significantDigits(min ... limits.upperBound)
    }
    
    @inlinable func editableValidation(numberOfIntegers: Int, numberOfDecimals: Int) -> Bool {
        numberOfIntegers + numberOfDecimals <= limits.upperBound
    }
}

// MARK: - Strategies: Separate

@usableFromInline struct DecimalTextPrecisionSeparate: DecimalTextPrecisionStrategy {
    
    // MARK: Properties
    
    @usableFromInline let integers: ClosedRange<Int>
    @usableFromInline let decimals: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init(integers: ClosedRange<Int>, decimals: ClosedRange<Int>) {
        self.integers = integers
        self.decimals = decimals
    }
    
    // MARK: Strategy
    
    @inlinable func displayableStyle() -> Style {
        .integerAndFractionLength(integerLimits: integers, fractionLimits: decimals)
    }
    
    @inlinable func editableStyle(decimal: Bool) -> Style {
        let minIntegers = (decimal && integers.lowerBound > 0) ? 1 : 0
        return .integerAndFractionLength(integerLimits: minIntegers ... integers.upperBound, fractionLimits: 0 ... decimals.upperBound)
    }
    
    @inlinable func editableValidation(numberOfIntegers: Int, numberOfDecimals: Int) -> Bool {
        numberOfIntegers <= integers.upperBound && numberOfDecimals <= decimals.upperBound
    }
}
