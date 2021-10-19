//
//  NumberTextValues.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

// MARK: - NumberTextValues

public struct NumberTextValues<Item: NumberTextValuesItem> {
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
    
    @inlinable public static var all: Self {
        .init(min: min, max: max)
    }
    
    @inlinable public static func min(_ value: Number) -> Self {
        .init(min: value)
    }
    
    @inlinable public static func max(_ value: Number) -> Self {
        .init(max: value)
    }
    
    @inlinable public static func range(_ values: ClosedRange<Number>) -> Self {
        .init(min: values.lowerBound, max: values.upperBound)
    }
    
    // MARK: Utilities
    
    @inlinable func displayableStyle(_ decimal: Number) -> Number {
        Swift.max(min, Swift.min(decimal, max))
    }
    
    @inlinable func editableValidation(_ decimal: Number) -> Bool {
        Swift.min(min, Self.zero) <= decimal && decimal <= Swift.max(Self.zero, max)
    }
}

// MARK: - NumberTextValuesItem

public protocol NumberTextValuesItem {
    associatedtype Number: Comparable
    
    // MARK: Properties: Static
    
    static var zero: Number { get }
    static var  max: Number { get }
    static var  min: Number { get }
}
