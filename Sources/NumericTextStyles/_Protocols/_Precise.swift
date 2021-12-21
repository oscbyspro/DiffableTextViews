//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Precise

#warning("WIP")
public protocol _Precise {
    
    // MARK: Requirements
    
    @inlinable static var maxLosslessDigits: Int { get }
    @inlinable static var maxLosslessIntegerDigits:  Int { get }
    @inlinable static var maxLosslessFractionDigits: Int { get }
}

// MARK: - UsesIntegerPrecision

public  protocol _UsesIntegerPrecision: _Precise { }
public extension _UsesIntegerPrecision {
    
    // MARK: Implementations
    
    @inlinable static var maxLosslessIntegerDigits:  Int { maxLosslessDigits }
    @inlinable static var maxLosslessFractionDigits: Int { 0 }
}

// MARK: - UsesFloatingPointPrecision

public  protocol _UsesFloatingPointPrecision: _Precise { }
public extension _UsesFloatingPointPrecision {
    
    // MARK: Implementations

    @inlinable static var maxLosslessIntegerDigits:  Int { maxLosslessDigits }
    @inlinable static var maxLosslessFractionDigits: Int { maxLosslessDigits }
}
