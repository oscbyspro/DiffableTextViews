//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

// MARK: - Precise

public protocol Precise {
    
    // MARK: Requirements
    
    @inlinable static var maxLosslessDigits:        Int { get }
    @inlinable static var maxLosslessIntegerDigits: Int { get }
    @inlinable static var maxLosslessDecimalDigits: Int { get }
}

// MARK: - Precise: Descriptions

extension Precise {
    
    // MARK: Descriptions
    
    @inlinable static var isFloat:   Bool { maxLosslessDecimalDigits >= 0 }
    @inlinable static var isInteger: Bool { maxLosslessDecimalDigits == 0 }
}

// MARK: - Specialization: Integer

public  protocol PreciseInteger: Precise { }
public extension PreciseInteger {
    
    // MARK: Implementations
    
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { 0 }
}

// MARK: - Specialization: Float

public  protocol PreciseFloat: Precise { }
public extension PreciseFloat {
    
    // MARK: Implementations

    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { maxLosslessDigits }
}
