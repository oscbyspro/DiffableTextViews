//
//  Ints.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - Int

extension Int: NumericTextInt {
    
    // MARK: Implementation
    
    public static let maxLosslessTotalDigits: Int = String(maxLosslessValue).count
}

// MARK: - Int8

extension Int8: NumericTextInt {
    
    // MARK: Implementation
    
    @inlinable public static var maxLosslessTotalDigits: Int { 3 }
}

// MARK: - Int16

extension Int16: NumericTextInt {
    
    // MARK: Implementation
    
    @inlinable public static var maxLosslessTotalDigits: Int { 5 }
}

// MARK: - Int32

extension Int32: NumericTextInt {
    
    // MARK: Implementation
    
    @inlinable public static var maxLosslessTotalDigits: Int { 10 }
}

// MARK: Int64

extension Int64: NumericTextInt {
    
    // MARK: Implementation
    
    @inlinable public static var maxLosslessTotalDigits: Int { 19 }
}
