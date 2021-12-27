//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import struct Utilities.Cancellation

// MARK: - Bounds

/// Bounds that constrain values to a range.
///
/// - Requires: That (min ≤ zero ≤ max) and (min != max) to ensure intuitive behavior.
///
public struct Bounds<Value: Boundable> {

    // MARK: Properties
    
    @usableFromInline let lowerBound: Value
    @usableFromInline let upperBound: Value
    
    // MARK: Initializers
    
    #warning("Precondition: min <= max.")
    @inlinable init(lowerBound: Value = Value.minLosslessValue, upperBound: Value = Value.maxLosslessValue) {
        precondition(lowerBound != upperBound, "Bounds: constraint 'lowerBound != upperBound' was broken.")
        precondition(lowerBound <= Value.zero, "Bounds: constraint 'lowerBound <= Value.zero' was broken.")
        precondition(upperBound >= Value.zero, "Bounds: constraint 'upperBound >= Value.zero' was broken.")
        
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    // MARK: Initialiers: Static
    
    @inlinable public static var standard: Self {
        .init()
    }
    
    @inlinable public static func values(in range: ClosedRange<Value>) -> Self {
        .init(lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
    
    @inlinable public static func values(in range: PartialRangeFrom<Value>) -> Self {
        .init(lowerBound: range.lowerBound)
    }
    
    @inlinable public static func values(in range: PartialRangeThrough<Value>) -> Self {
        .init(upperBound: range.upperBound)
    }
    
    // MARK: Descriptions
    
    @inlinable var nonnegative: Bool {
        .zero <= lowerBound
    }
    
    @inlinable var nonpositive: Bool {
        upperBound <= .zero
    }
    
    // MARK: Utilities
        
    @inlinable func clamp(_ value: inout Value) {
        value = Swift.max(lowerBound, Swift.min(value, upperBound))
    }
    
    // MARK: Validation
    
    @inlinable func validate(contains value: Value) throws {
        guard lowerBound <= value && value <= upperBound else {
            throw .cancellation(reason: "Bounds from \(lowerBound) to \(upperBound) do not contain: \(value).")
        }
    }
}
