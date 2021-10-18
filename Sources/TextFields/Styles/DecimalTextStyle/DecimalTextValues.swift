//
//  DecimalTextRange.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-17.
//

import struct Foundation.Decimal

// MARK: - DecimalTextValues

public struct DecimalTextValues {
    
    // MARK: Properties: Static
    
    public static let limit = Decimal(string: String(repeating: "9", count: 38))!

    // MARK: Properties
    
    public let min: Decimal
    public let max: Decimal
    
    // MARK: Initializers
    
    @inlinable init(min: Decimal = -Self.limit, max: Decimal = Self.limit) {
        precondition(min <= max)
        
        self.min = min
        self.max = max
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static var all: Self {
        .init(min: -limit, max: limit)
    }
    
    @inlinable public static func min(_ value: Decimal) -> Self {
        .init(min: value)
    }
    
    @inlinable public static func max(_ value: Decimal) -> Self {
        .init(max: value)
    }
    
    @inlinable public static func range(_ values: ClosedRange<Decimal>) -> Self {
        .init(min: values.lowerBound, max: values.upperBound)
    }
    
    // MARK: Utilities
    
    @inlinable func displayableStyle(_ decimal: Decimal) -> Decimal {
        Swift.max(min, Swift.min(decimal, max))
    }
    
    @inlinable func editableValidation(_ decimal: Decimal) -> Bool {
        Swift.min(min, 0) <= decimal && decimal <= Swift.max(0, max)
    }
}
