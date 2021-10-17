//
//  DecimalTextPrecision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-17.
//

import Foundation

// MARK: - DecimalTextPrecision

public struct DecimalTextPrecision {
    @usableFromInline typealias This = Self
    
    // MARK: Properties
    
    @usableFromInline let max: Int
    @usableFromInline let digits: Digits?
    
    // MARK: Properties: Static
    
    public static let max = 38
    
    // MARK: Initializers
    
    @inlinable init(max: Int = max, digits: Digits? = nil) {
        precondition(max <= Self.max)
        
        self.max = max
        self.digits = digits
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func limit(max: Int) -> Self {
        Self.init(max: max)
    }
    
    @inlinable public static func limit(max: Int = max, integers: ClosedRange<Int>) -> Self {
        Self.init(max: max, digits: Digits(integers: integers, decimals: complement(to: integers, max: max)))
    }
    
    @inlinable public static func limit(max: Int = max, decimals: ClosedRange<Int>) -> Self {
        Self.init(max: max, digits: Digits(integers: complement(to: decimals, max: max), decimals: decimals))
    }
    
    @inlinable public static func limit(max: Int = max, integers: ClosedRange<Int>, decimals: ClosedRange<Int>) -> Self {
        Self.init(max: max, digits: Digits(integers: integers, decimals: decimals))
    }
    
    // MARK: Initializers: Static, Helpers
    
    @inlinable static func complement(to range: ClosedRange<Int>, max: Int) -> ClosedRange<Int> {
        0 ... (max - range.upperBound)
    }
    
    // MARK: Digits
    
    @usableFromInline struct Digits {
        
        // MARK: Properties
        
        @usableFromInline let integers: ClosedRange<Int>
        @usableFromInline let decimals: ClosedRange<Int>
        
        // MARK: Initializers
        
        @inlinable init(integers: ClosedRange<Int>, decimals: ClosedRange<Int>) {
            precondition(integers.upperBound + decimals.upperBound <= This.max)
            
            self.integers = integers
            self.decimals = decimals
        }
    }
}

// MARK: - Interoperabilities: DecimalTextComponents

extension DecimalTextPrecision {
    
    // MARK: Utilities
    
    @inlinable func validate(editable components: DecimalTextComponents) -> Bool {
        let numberOfIntegerDigits = components.integerDigits.count
        let numberOfDecimalDigits = components.decimalDigits.count
        
        if let digits = digits {
            guard numberOfIntegerDigits <= digits.integers.upperBound else { return false }
            guard numberOfDecimalDigits <= digits.decimals.upperBound else { return false }
        }
        
        return numberOfIntegerDigits + numberOfDecimalDigits <= max
    }
}

// MARK: - Interoperabilities: Decimal.FormatStyle.Configuration.Precision

@available(iOS 15.0, *)
extension DecimalTextPrecision {
    
    // MARK: Utilities
    
    @inlinable func displayableStyle() -> Decimal.FormatStyle.Configuration.Precision {
        if let digits = digits {
            return .integerAndFractionLength(integerLimits: digits.integers, fractionLimits: digits.integers)
        }
        
        return .significantDigits(max)
    }
    
    @inlinable func editableStyle(minIntegers: Int = 0) -> Decimal.FormatStyle.Configuration.Precision {
        if let digits = digits {
            return .integerAndFractionLength(integerLimits: minIntegers...digits.integers.upperBound, fractionLimits: 0...digits.integers.upperBound)
        }
        
        return .significantDigits(max)
    }
}
