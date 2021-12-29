//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Precise

public protocol Precise {
    
    // MARK: Requirements
    
    @inlinable static var maxLosslessIntegerDigits:     Int { get }
    @inlinable static var maxLosslessFractionDigits:    Int { get }
    @inlinable static var maxLosslessSignificantDigits: Int { get }
}

extension Precise {
    
    // MARK: Values
    
    @inlinable static var minLosslessIntegerDigits:     Int { 1 }
    @inlinable static var minLosslessFractionDigits:    Int { 0 }
    @inlinable static var minLosslessSignificantDigits: Int { 1 }
    
    // MARK: Bounds
    
    @inlinable static var losslessIntegerLimits: ClosedRange<Int> {
        minLosslessIntegerDigits ... maxLosslessIntegerDigits
    }
    
    @inlinable static var losslessFractionLimits: ClosedRange<Int> {
        minLosslessFractionDigits ... maxLosslessFractionDigits
    }
    
    @inlinable static var losslessSignificantLimits: ClosedRange<Int> {
        minLosslessSignificantDigits ... maxLosslessSignificantDigits
    }
}

// MARK: - Precise x FloatingPoint

public protocol  PreciseFloatingPoint: Precise { }
public extension PreciseFloatingPoint {
    
    // MARK: Implementation

    @inlinable static var maxLosslessIntegerDigits: Int {
        maxLosslessSignificantDigits
    }
    
    @inlinable static var maxLosslessFractionDigits: Int {
        maxLosslessSignificantDigits
    }
}

// MARK: - Precise x Integer

public protocol  PreciseInteger: Precise { }
public extension PreciseInteger {
    
    // MARK: Implementation
    
    @inlinable static var maxLosslessIntegerDigits: Int {
        maxLosslessSignificantDigits
    }
    
    @inlinable static var maxLosslessFractionDigits: Int {
        Int.zero
    }
}
