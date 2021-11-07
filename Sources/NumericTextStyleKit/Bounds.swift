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
    
    @inlinable public static var zero:             Value { Value.zero }
    @inlinable public static var maxLosslessValue: Value { Value.maxLosslessValue  }
    @inlinable public static var minLosslessValue: Value { Value.minLosslessValue  }

    // MARK: Properties
    
    public let minLosslessValue: Value
    public let maxLosslessValue: Value
    
    // MARK: Initializers
    
    @inlinable init(minLosslessValue: Value = Self.minLosslessValue, maxLosslessValue: Value = Self.maxLosslessValue) {
        precondition(minLosslessValue <= maxLosslessValue)
        
        self.minLosslessValue = Swift.max(minLosslessValue, Self.minLosslessValue)
        self.maxLosslessValue = Swift.min(Self.maxLosslessValue, maxLosslessValue)
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func min(_ value: Value) -> Self {
        .init(minLosslessValue: value)
    }
    
    @inlinable public static func max(_ value: Value) -> Self {
        .init(maxLosslessValue: value)
    }
    
    @inlinable public static func inside(of values: ClosedRange<Value>) -> Self {
        .init(minLosslessValue: values.lowerBound, maxLosslessValue: values.upperBound)
    }
    
    // MARK: Initialiers: Static
    
    @inlinable public static var all: Self {
        .inside(of: minLosslessValue...maxLosslessValue)
    }
    
    @inlinable public static var nonnegative: Self {
        .min(zero)
    }
    
    @inlinable public static var nonpositive: Self {
        .max(zero)
    }
    
    // MARK: Descriptions
    
    @inlinable var nonnegative: Bool {
        minLosslessValue >= Value.zero
    }
    
    @inlinable var nonpositive: Bool {
        maxLosslessValue <= Value.zero
    }
    
    // MARK: Utilities
    
    @inlinable func displayableStyle(_ value: Value) -> Value {
        Swift.max(minLosslessValue, Swift.min(value, maxLosslessValue))
    }
    
    @inlinable func editableValidation(_ value: Value) -> Bool {
        Swift.min(minLosslessValue, Self.zero) <= value && value <= Swift.max(Self.zero, maxLosslessValue)
    }
}

#endif
