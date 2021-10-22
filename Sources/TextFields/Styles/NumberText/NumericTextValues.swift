//
//  NumericTextValues.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

// MARK: - NumberTextValues

public struct NumericTextValues<Item: NumericTextValuesItem> {
    public typealias Number = Item.Number
    
    // MARK: Properties: Static
    
    @inlinable public static var  max: Number { Item.max  }
    @inlinable public static var  min: Number { Item.min  }
    @inlinable public static var zero: Number { Item.zero }

    // MARK: Properties
    
    public let min: Number
    public let max: Number
    
    // MARK: Initializers
    
    @inlinable init(min: Number = Self.min, max: Number = Self.max) {
        precondition(min <= max)
        
        self.min = Swift.max(min, Self.min)
        self.max = Swift.min(Self.max, max)
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func min(_ value: Number) -> Self {
        .init(min: value)
    }
    
    @inlinable public static func max(_ value: Number) -> Self {
        .init(max: value)
    }
    
    @inlinable public static func range(_ values: ClosedRange<Number>) -> Self {
        .init(min: values.lowerBound, max: values.upperBound)
    }
    
    // MARK: Initialiers: Static
    
    @inlinable public static var all: Self {
        .range(min...max)
    }
    
    @inlinable public static var nonnegative: Self {
        .min(zero)
    }
    
    @inlinable public static var nonpositive: Self {
        .max(zero)
    }
    
    // MARK: Descriptions
    
    @inlinable var nonnegative: Bool {
        min >= Item.zero
    }
    
    @inlinable var nonpositive: Bool {
        max <= Item.zero
    }
    
    // MARK: Utilities
    
    @inlinable func displayableStyle(_ value: Number) -> Number {
        Swift.max(min, Swift.min(value, max))
    }
    
    @inlinable func editableValidation(_ value: Number) -> Bool {
        Swift.min(min, Self.zero) <= value && value <= Swift.max(Self.zero, max)
    }
}
