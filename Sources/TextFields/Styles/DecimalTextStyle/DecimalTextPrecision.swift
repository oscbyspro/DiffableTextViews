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
    
    public static let maximum = 38
    public static let domain = 0 ..< maximum + 1
    
    public static let defaultIntegersLowerBound = 1
    public static let defaultDecimalsLowerBound = 0
    
    // MARK: Properties
    
    @usableFromInline let strategy: Strategy
    
    // MARK: Initializers
    
    @inlinable init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    // MARK: Initializers: Defaults
    
    @inlinable public static var max: Self {
        .digits(maximum)
    }
    
    // MARK: Initializers: Static, Total

    @inlinable public static func digits<R: RangeExpression>(_ limits: R) -> Self where R.Bound == Int {
        let limits = limits.relative(to: domain)
                
        return .init(strategy: DecimalTextPrecisionTotal(limits))
    }
    
    @inlinable public static func digits(_ limits: Int) -> Self {
        digits(defaultIntegersLowerBound ... limits)
    }
    
    // MARK: Initializers: Static, Separate
        
    @inlinable public static func digits<R0: RangeExpression, R1: RangeExpression>(integers: R0, decimals: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        let integers = integers.relative(to: domain)
        let decimals = decimals.relative(to: domain)
        
        precondition(decimals.max()! + decimals.max()! < domain.upperBound)
        
        return .init(strategy: DecimalTextPrecisionSeparate(integers: integers, decimals: decimals))
    }
    
    @inlinable public static func digits<R: RangeExpression>(integers: R) -> Self where R.Bound == Int {
        let integers = integers.relative(to: domain)
        
        return digits(integers: integers, decimals: defaultDecimalsLowerBound ..< (domain.upperBound - integers.upperBound))
    }
    
    @inlinable public static func digits<R: RangeExpression>(decimals: R) -> Self where R.Bound == Int {
        let decimals = decimals.relative(to: domain)

        return digits(integers: defaultIntegersLowerBound ..< (domain.upperBound - decimals.upperBound), decimals: decimals)
    }
    
    @inlinable public static func digits(integers: Int, decimals: Int) -> Self {
        digits(integers: defaultIntegersLowerBound ... integers, decimals: defaultDecimalsLowerBound ... decimals)
    }
    
    @inlinable public static func digits(integers: Int) -> Self {
        digits(integers: integers, decimals: maximum - integers)
    }
    
    @inlinable public static func digits(decimals: Int) -> Self {
        digits(integers: maximum - decimals, decimals: decimals)
    }
}

// MARK: - Interoperabilities

@available(iOS 15.0, *)
extension DecimalTextPrecision {
    
    // MARK: Utilities
    
    @inlinable func displayableStyle() -> Decimal.FormatStyle.Configuration.Precision {
        strategy.displayableStyle()
    }
    
    @inlinable func editableStyle() -> Decimal.FormatStyle.Configuration.Precision {
        strategy.editableStyle()
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
    
    func editableStyle() -> Style
    
    func editableValidation(numberOfIntegers: Int, numberOfDecimals: Int) -> Bool
}

// MARK: - Strategies: Total

@usableFromInline struct DecimalTextPrecisionTotal: DecimalTextPrecisionStrategy {
    
    // MARK: Properties
    
    @usableFromInline let limits: Range<Int>
    
    // MARK: Initializers
    
    @inlinable init(_ limits: Range<Int>) {
        self.limits = limits
    }
    
    // MARK: Strategy
    
    @inlinable func displayableStyle() -> Style {
        .significantDigits(limits)
    }
    
    @inlinable func editableStyle() -> Style {
        let min = limits.contains(0) ? 0 : 1
        return .significantDigits(min ..< limits.upperBound)
    }
    
    @inlinable func editableValidation(numberOfIntegers: Int, numberOfDecimals: Int) -> Bool {
        numberOfIntegers + numberOfDecimals < limits.upperBound
    }
}

// MARK: - Strategies: Separate

@usableFromInline struct DecimalTextPrecisionSeparate: DecimalTextPrecisionStrategy {
    
    // MARK: Properties
    
    @usableFromInline let integers: Range<Int>
    @usableFromInline let decimals: Range<Int>
    
    // MARK: Initializers
    
    @inlinable init(integers: Range<Int>, decimals: Range<Int>) {
        self.integers = integers
        self.decimals = decimals
    }
    
    // MARK: Strategy
    
    @inlinable func displayableStyle() -> Style {
        .integerAndFractionLength(integerLimits: integers, fractionLimits: decimals)
    }
    
    @inlinable func editableStyle() -> Style {
        let minIntegers = integers.contains(0) ? 0 : 1
        return .integerAndFractionLength(integerLimits: minIntegers ..< integers.upperBound, fractionLimits: 0 ..< decimals.upperBound)
    }
    
    @inlinable func editableValidation(numberOfIntegers: Int, numberOfDecimals: Int) -> Bool {
        numberOfIntegers < integers.upperBound && numberOfDecimals < decimals.upperBound        
    }
}
