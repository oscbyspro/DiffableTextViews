//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Bounds

/// Bounds that constrain values to a range.
///
/// Requires that lowerBound ≤ zero ≤ upperBound to ensure intuitive behavior.
///
public struct _Bounds<Value: _Boundable> {

    // MARK: Properties
    
    public let lowerBound: Value
    public let upperBound: Value
    
    // MARK: Initializers
    
    @inlinable init(lowerBound: Value = Value.minLosslessValue, upperBound: Value = Value.maxLosslessValue) {
        precondition(lowerBound <= Value.zero, "Precondition: min <= 0 unsatisfied.")
        precondition(upperBound >= Value.zero, "Precondition: max >= 0 unsatisfied.")

        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    // MARK: Initialiers: Static
    
    @inlinable public static var none: Self {
        .init()
    }
    
    @inlinable public static func values(in range: ClosedRange<Value>) -> Self {
        .init(lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
    
    @inlinable public static func values(in range: PartialRangeFrom<Value>) -> Self {
        .init(lowerBound: range.lowerBound, upperBound: Value.minLosslessValue)
    }
    
    @inlinable public static func values(in range: PartialRangeThrough<Value>) -> Self {
        .init(lowerBound: Value.maxLosslessValue, upperBound: range.upperBound)
    }
    
    // MARK: Utilities
    
    #warning("Unused.")
    @inlinable func bounded(_ value: Value) -> Value {
        max(lowerBound, min(value, upperBound))
    }

    #warning("Unused.")
    @inlinable func validate(_ value: Value) -> Bool {
        lowerBound <= value && value <= upperBound
    }
}
