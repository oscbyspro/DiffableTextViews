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
    @inlinable static var maxLosslessDigitsInInteger: Int { get }
    @inlinable static var maxLosslessDigitsInFraction: Int { get }
}

// MARK: - UsesIntegerPrecision

public  protocol _UsesIntegerPrecision: _Precise { }
public extension _UsesIntegerPrecision {
    
    // MARK: Implementations
    
    @inlinable static var maxLosslessDigitsInInteger:  Int { maxLosslessDigits }
    @inlinable static var maxLosslessDigitsInFraction: Int { 0 }
}

// MARK: - UsesFloatPrecision

public  protocol _UsesFloatPrecision: _Precise { }
public extension _UsesFloatPrecision {
    
    // MARK: Implementations

    @inlinable static var maxLosslessDigitsInInteger:  Int { maxLosslessDigits }
    @inlinable static var maxLosslessDigitsInFraction: Int { maxLosslessDigits }
}
