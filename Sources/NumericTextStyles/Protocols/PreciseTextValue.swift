//
//  PreciseTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - PreciseTextValue

public protocol PreciseTextValue {
    
    // MARK: Requirements
    
    @inlinable static var maxLosslessTotalDigits: Int { get }
    @inlinable static var maxLosslessIntegerDigits: Int { get }
    @inlinable static var maxLosslessFractionDigits: Int { get }
}

// MARK: - UsesIntegerPrecision

public  protocol _UsesIntegerPrecision: PreciseTextValue { }
public extension _UsesIntegerPrecision {
    
    // MARK: Implementation
    
    @inlinable static var maxLosslessIntegerDigits:  Int { maxLosslessTotalDigits }
    @inlinable static var maxLosslessFractionDigits: Int { 0 }
}

// MARK: - UsesFloatingPointPrecision

public  protocol _UsesFloatingPointPrecision: PreciseTextValue { }
public extension _UsesFloatingPointPrecision {
    
    // MARK: Implementation

    @inlinable static var maxLosslessIntegerDigits:  Int { maxLosslessTotalDigits }
    @inlinable static var maxLosslessFractionDigits: Int { maxLosslessTotalDigits }
}
