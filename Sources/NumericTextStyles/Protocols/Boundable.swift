//
//  Boundable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Boundable

public protocol Boundable: Comparable {
    
    // MARK: Requirements
    
    /// The zero value.
    @inlinable static var zero: Self { get }
    
    /// - Less than or equal to zero.
    @inlinable static var minLosslessValue: Self { get }
    
    /// - Greater than or equal to zero.
    @inlinable static var maxLosslessValue: Self { get }
}

// MARK: - BoundableFloatingPoint

@usableFromInline protocol BoundableFloatingPoint: Boundable, BinaryFloatingPoint { }

// MARK: - BoundableFloatingPoint: Details

extension BoundableFloatingPoint {
    
    // MARK: Implementation
    
    @inlinable public static var minLosslessValue: Self {
        -maxLosslessValue
    }
}

// MARK: - BoundableInteger

@usableFromInline protocol BoundableInteger: Boundable, FixedWidthInteger { }

// MARK: - BoundableInteger: Details

extension BoundableInteger {
    
    // MARK: Implementation
    
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }
}

