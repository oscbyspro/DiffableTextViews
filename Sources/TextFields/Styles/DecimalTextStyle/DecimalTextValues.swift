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
    public static let stride = Decimal(string: "0." + String(repeating: "0", count: 37) + "1")!

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
        
    @inlinable public static func range(_ values: ClosedRange<Decimal>) -> Self {
        .init(min: Swift.max(-limit, values.lowerBound), max: Swift.min(values.upperBound, limit))
    }
    
    @inlinable public static func range(_ values: Range<Decimal>) -> Self {
        range(values.lowerBound ... values.upperBound + stride)
    }
    
    // MARK: Initializers: Static

    @inlinable public static var nonnegative: Self {
        range(0 ... limit)
    }
    
    @inlinable public static var nonpositive: Self {
        range(-limit ... 0)
    }

    // MARK: Utilities
    
    @inlinable func contains(_ decimal: Decimal) -> Bool {
        min <= decimal && decimal <= max
    }
    
    @inlinable var nonnegative: Bool {
        min >= 0
    }
}
