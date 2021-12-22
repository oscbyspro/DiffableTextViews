//
//  NumberTextBounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Bounds

/// Bounds that constrain values to a range.
///
/// Requires that lowerBound ≤ zero ≤ upperBound to ensure intuitive behavior.
///
public struct NumberTextBounds<Value: BoundableTextValue> {

    // MARK: Properties
    
    public let lowerBound: Value
    public let upperBound: Value
    
    // MARK: Initializers
    
    @inlinable init(lowerBound: Value = Value.minLosslessValue, upperBound: Value = Value.maxLosslessValue) {
        precondition(lowerBound <= Value.zero, "Bounds: contraint 'lowerBound <= 0' was broken.")
        precondition(upperBound >= Value.zero, "Bounds: contraint 'upperBound >= 0' was broken.")

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
    
    // MARK: Utilities
    
    @inlinable func bounded(_ value: Value) -> Value {
        Swift.max(lowerBound, Swift.min(value, upperBound))
    }

    @inlinable func contains(_ value: Value) -> Bool {
        lowerBound <= value && value <= upperBound
    }
}
