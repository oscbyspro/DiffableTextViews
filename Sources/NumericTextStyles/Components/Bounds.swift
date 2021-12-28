//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Bounds

/// A model that constrains values to a closed range.
public struct Bounds<Value: Boundable> {

    // MARK: Properties
    
    @usableFromInline let values: ClosedRange<Value>
    
    // MARK: Initializers
    
    @inlinable init(min: Value = Value.minLosslessValue, max: Value = Value.maxLosslessValue) {
        self.values = min ... max
    }
    
    // MARK: Getters
    
    @inlinable var min: Value {
        values.lowerBound
    }
    
    @inlinable var max: Value {
        values.upperBound
    }
    
    // MARK: Initialiers: Static
    
    @inlinable public static var standard: Self {
        .init()
    }
    
    @inlinable public static func values(_ values: ClosedRange<Value>) -> Self {
        .init(min: values.lowerBound, max: values.upperBound)
    }
    
    @inlinable public static func values(_ values: PartialRangeFrom<Value>) -> Self {
        .init(min: values.lowerBound)
    }
    
    @inlinable public static func values(_ values: PartialRangeThrough<Value>) -> Self {
        .init(max: values.upperBound)
    }
    
    // MARK: Utilities
        
    @inlinable func clamp(_ value: inout Value) {
        value = Swift.max(min, Swift.min(value, max))
    }
    
    @inlinable func contains(_ value: Value) -> Bool {
        values.contains(value)
    }
}

// MARK: - Bounds: Conversions

extension Bounds: CustomStringConvertible {
    
    // MARK: Implementation
    
    @inlinable public var description: String {
        "[\(min),\(max)]"
    }
}
