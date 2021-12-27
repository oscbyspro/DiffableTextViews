//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Precise

public protocol Precise {
    
    // MARK: Requirements
    
    @inlinable static var maxLosslessIntegerDigits: Int { get }
    @inlinable static var maxLosslessFractionDigits: Int { get }
    @inlinable static var maxLosslessSignificantDigits: Int { get }
}

// MARK: - Precise: Integer

public  protocol PreciseInteger: Precise { }
public extension PreciseInteger {
    
    // MARK: Implementation
    
    @inlinable static var maxLosslessIntegerDigits: Int {
        maxLosslessSignificantDigits
    }
    
    @inlinable static var maxLosslessFractionDigits: Int {
        Int.zero
    }
}

// MARK: - Precise: FloatingPoint

public  protocol PreciseFloatingPoint: Precise { }
public extension PreciseFloatingPoint {
    
    // MARK: Implementation

    @inlinable static var maxLosslessIntegerDigits: Int {
        maxLosslessSignificantDigits
    }
    
    @inlinable static var maxLosslessFractionDigits: Int {
        maxLosslessSignificantDigits
    }
}
