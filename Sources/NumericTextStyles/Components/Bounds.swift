//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Bounds

/// Bounds that constrain values to a range.
///
/// Requires that lowerBound ≤ zero ≤ upperBound and lowerBound != upperBound to ensure intuitive behavior.
///
public struct Bounds<Value: Boundable> {

    // MARK: Properties
    
    @usableFromInline let lowerBound: Value
    @usableFromInline let upperBound: Value
    
    // MARK: Initializers
    
    @inlinable init(lowerBound: Value = Value.minLosslessValue, upperBound: Value = Value.maxLosslessValue) {
        precondition(lowerBound != upperBound, "Bounds: constraint 'lowerBound != upperBound' was broken.")
        precondition(lowerBound <= Value.zero, "Bounds: constraint 'lowerBound <= Value.zero' was broken.")
        precondition(upperBound >= Value.zero, "Bounds: constraint 'upperBound >= Value.zero' was broken.")

        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    // MARK: Initialiers: Static
    
    @inlinable public static var max: Self {
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
    
    @inlinable var nonegative: Bool {
        .zero <= lowerBound
    }
    
    @inlinable var nonpositive: Bool {
        upperBound <= .zero
    }
    
    // MARK: Utilities

    @inlinable func contains(_ value: Value) -> Bool {
        lowerBound <= value && value <= upperBound
    }
    
    @inlinable func clamp(_ value: inout Value) {
        value = Swift.max(lowerBound, Swift.min(value, upperBound))
    }
}
