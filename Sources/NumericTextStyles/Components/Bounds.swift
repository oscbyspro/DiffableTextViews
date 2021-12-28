//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import struct Utilities.Cancellation

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
    
    // MARK: Descriptions
    
    @inlinable var positive: Bool {
        Value.zero <= min && Value.zero < max
    }
    
    @inlinable var negative: Bool {
        min < Value.zero && max <= Value.zero
    }

    @inlinable var nonpositive: Bool {
        max <= Value.zero
    }

    @inlinable var nonnegative: Bool {
        Value.zero <= min
    }
    
    // MARK: Utilities
        
    @inlinable func clamp(_ value: inout Value) {
        value = Swift.max(min, Swift.min(value, max))
    }
    
    // MARK: Validation
    
    @inlinable func validate(contains value: Value) throws {
        guard values.contains(value) else {
            throw .cancellation(reason: "Bounds from \(min) to \(max) do not contain: \(value).")
        }
    }
}
