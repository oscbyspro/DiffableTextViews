//
//  DecimalTextPrecision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-17.
//

// MARK: - DecimalTextPrecision

#warning("Should make it work properly for editing/validation and displaying.")
public struct DecimalTextPrecision {
    
    // MARK: Properties: Static
    
    @usableFromInline static let maxSignificantDigits = 38
    
    // MARK: Properties
    
    @usableFromInline let validate: (DecimalTextComponents) -> Bool
    
    // MARK: Initializers
    
    @inlinable init(_ validate: @escaping (DecimalTextComponents) -> Bool) {
        self.validate = validate
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func digits(integers: ClosedRange<Int>, decimals: ClosedRange<Int>) -> Self {
        precondition((integers.upperBound + decimals.upperBound) <= maxSignificantDigits)
        
        return .init { components in
            integers.contains(components.integerDigits.count) && decimals.contains(components.decimalDigits.count)
        }
    }
    
    @inlinable public static func significands<R: RangeExpression>(_ limit: R) -> Self where R.Bound == Int {
        precondition(!limit.contains(maxSignificantDigits + 1))
        
        return .init { components in
            limit.contains(components.integerDigits.count + components.decimalDigits.count)
        }
    }
}
