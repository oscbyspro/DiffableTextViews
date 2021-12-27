//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Precise

public protocol Precise {
    
    // MARK: Requirements
    
    @inlinable static var maxLosslessValueDigits: Int { get }
    @inlinable static var maxLosslessUpperDigits: Int { get }
    @inlinable static var maxLosslessLowerDigits: Int { get }
}

// MARK: - Precise: Integer

public  protocol PreciseInteger: Precise { }
public extension PreciseInteger {
    
    // MARK: Implementation
    
    @inlinable static var maxLosslessUpperDigits: Int { maxLosslessValueDigits }
    @inlinable static var maxLosslessLowerDigits: Int { 0 }
}

// MARK: - Precise: FloatingPoint

public  protocol PreciseFloatingPoint: Precise { }
public extension PreciseFloatingPoint {
    
    // MARK: Implementation

    @inlinable static var maxLosslessUpperDigits: Int { maxLosslessValueDigits }
    @inlinable static var maxLosslessLowerDigits: Int { maxLosslessValueDigits }
}
