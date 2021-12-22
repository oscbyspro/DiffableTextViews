//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Precise

public protocol Precise {
    
    // MARK: Requirements
    
    @inlinable static var maxLosslessTotalDigits: Int { get }
    @inlinable static var maxLosslessIntegerDigits: Int { get }
    @inlinable static var maxLosslessFractionDigits: Int { get }
}

// MARK: - Precise: Integer

public  protocol UsesIntegerPrecision: Precise { }
public extension UsesIntegerPrecision {
    
    // MARK: Implementation
    
    @inlinable static var maxLosslessIntegerDigits:  Int { maxLosslessTotalDigits }
    @inlinable static var maxLosslessFractionDigits: Int { 0 }
}

// MARK: - Precise: FloatingPoint

public  protocol UsesFloatingPointPrecision: Precise { }
public extension UsesFloatingPointPrecision {
    
    // MARK: Implementation

    @inlinable static var maxLosslessIntegerDigits:  Int { maxLosslessTotalDigits }
    @inlinable static var maxLosslessFractionDigits: Int { maxLosslessTotalDigits }
}
