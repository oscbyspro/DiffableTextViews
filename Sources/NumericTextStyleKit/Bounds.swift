//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

// MARK: - Bounds

@usableFromInline struct Bounds<Value: NumericTextStyleKit.Value>: NumericTextBounds {
    
    // MARK: Properties: Static
    
    @inlinable public static var zero: Value { Value.zero }
    @inlinable public static var  max: Value { Value.maxLosslessValue }
    @inlinable public static var  min: Value { Value.maxLosslessValue }

    // MARK: Properties
    
    public let min: Value
    public let max: Value
    
    // MARK: Initializers
    
    @inlinable init(min: Value = Self.min, max: Value = Self.max) {
        precondition(min <= max)
        
        self.min = Swift.max(min, Self.min)
        self.max = Swift.min(Self.max, max)
    }
    
    // MARK: Initialiers: Static
    
    @inlinable static var all: Self {
        .values(in: min...max)
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func min(_ value: Value) -> Self {
        .init(min: value)
    }
    
    @inlinable static func max(_ value: Value) -> Self {
        .init(max: value)
    }
    
    @inlinable static func values(in values: ClosedRange<Value>) -> Self {
        .init(min: values.lowerBound, max: values.upperBound)
    }
    
    // MARK: Descriptions
    
    @inlinable var nonnegative: Bool {
        min >= Value.zero
    }
    
    @inlinable var nonpositive: Bool {
        max <= Value.zero
    }
    
    // MARK: Utilities
    
    @inlinable func displayableStyle(_ value: Value) -> Value {
        Swift.max(min, Swift.min(value, max))
    }
    
    @inlinable func editableValidation(_ value: Value) -> Bool {
        Swift.min(min, Self.zero) <= value && value <= Swift.max(Self.zero, max)
    }
}

#endif
