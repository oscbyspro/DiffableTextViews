//
//  UInts.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

// MARK: - UInt

extension UInt: NumberTextUInt {
    
    // MARK: Implementation
        
    /// Apple, please fix IntegerFormatStyleUInt, it uses an Int.
    @inlinable public static var maxLosslessValue: UInt {
        UInt(Int.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt, it uses an Int.
    @inlinable public static var maxLosslessTotalDigits: Int {
        Int.maxLosslessTotalDigits
    }
}

// MARK: - UInt8

extension UInt8: NumberTextUInt {
    
    // MARK: Implementation

    @inlinable public static var maxLosslessTotalDigits: Int { 3 }
}

// MARK: - UInt16

extension UInt16: NumberTextUInt {
    
    // MARK: Implementation
    
    @inlinable public static var maxLosslessTotalDigits: Int { 5 }
}

// MARK: - UInt32

extension UInt32: NumberTextUInt {
    
    // MARK: Implementation
    
    @inlinable public static var maxLosslessTotalDigits: Int { 10 }
}

// MARK: - UInt64

extension UInt64: NumberTextUInt {
    
    // MARK: Implementation
    
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt64 {
        UInt64(Int64.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessTotalDigits: Int {
        Int64.maxLosslessTotalDigits
    }
}
