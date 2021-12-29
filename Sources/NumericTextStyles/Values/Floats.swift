//
//  Floats.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

// MARK: - Float16

extension Float16: ValuableFloatingPoint {
    
    // MARK: Implementation
    
    public static let maxLosslessValue: Self = 999
    public static let maxLosslessSignificantDigits: Int = 3
}

// MARK: - Float32

extension Float32: ValuableFloatingPoint {
    
    // MARK: Implementation
        
    public static let maxLosslessValue: Self = 9_999_999
    public static let maxLosslessSignificantDigits: Int = 7
}

// MARK: - Float64

extension Float64: ValuableFloatingPoint {
    
    // MARK: Implementation
        
    public static let maxLosslessValue: Self = 999_999_999_999_999
    public static let maxLosslessSignificantDigits: Int = 15
}
