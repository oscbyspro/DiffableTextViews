//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

// MARK: - Bounds

@usableFromInline struct Bounds<Value: NumericTextStyleKit.Value>: NumericTextBounds {

    // MARK: Properties
    
    public let min: Value
    public let max: Value
    
    // MARK: Initializers
    
    @inlinable init(min: Value = Value.minLosslessValue, max: Value = Value.maxLosslessValue) {
        precondition(min <= max)
        
        self.min = Swift.max(min, Value.minLosslessValue)
        self.max = Swift.min(Value.maxLosslessValue, max)
    }
    
    // MARK: Initialiers: Static
    
    @inlinable static var all: Self {
        .values(in: Value.minLosslessValue...Value.maxLosslessValue)
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func min(_ value: Value) -> Self {
        .init(min: value)
    }
    
    @inlinable static func max(_ value: Value) -> Self {
        .init(max: value)
    }
    
    @inlinable static func values(in expression: ClosedRange<Value>) -> Self {
        .init(min: expression.lowerBound, max: expression.upperBound)
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
        Swift.min(min, Value.zero) <= value && value <= Swift.max(Value.zero, max)
    }
}

#endif
