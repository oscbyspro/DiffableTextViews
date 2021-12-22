//
//  Floats.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

// MARK: - Float16

extension Float16: NumericTextFloat {
    
    // MARK: Implementation
    
    @inlinable public static var maxLosslessValue: Self { 999 }
    @inlinable public static var maxLosslessTotalDigits: Int { 3 }
}

// MARK: - Float32

extension Float32: NumericTextFloat {
    
    // MARK: Implementation
        
    @inlinable public static var maxLosslessValue: Self { 9_999_999 }
    @inlinable public static var maxLosslessTotalDigits: Int { 7 }
}

// MARK: - Float64

extension Float64: NumericTextFloat {
    
    // MARK: Implementation
        
    @inlinable public static var maxLosslessValue: Self { 999_999_999_999_999 }
    @inlinable public static var maxLosslessTotalDigits: Int { 15 }
}
