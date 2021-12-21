//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Bounds

public struct _Bounds<Value: Comparable> {

    // MARK: Properties
    
    public let min: Value?
    public let max: Value?
    
    // MARK: Initializers
    
    @inlinable init(min: Value? = nil, max: Value? = nil) {
        self.min = min
        self.max = max
    }
    
    // MARK: Initialiers: Static
    
    @inlinable public static var none: Self {
        .init(min: nil, max: nil)
    }
    
    @inlinable public static func values(in range: ClosedRange<Value>) -> Self {
        .init(min: range.lowerBound, max: range.upperBound)
    }
    
    @inlinable public static func values(in range: PartialRangeFrom<Value>) -> Self {
        .init(min: range.lowerBound, max: nil)
    }
    
    @inlinable public static func values(in range: PartialRangeThrough<Value>) -> Self {
        .init(min: nil, max: range.upperBound)
    }
}
