//
//  Ints.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - Int

extension Int: ValuableInt {
    
    // MARK: Implementation
    
    public static let maxLosslessSignificantDigits: Int = String(maxLosslessValue).count
}

// MARK: - Int8

extension Int8: ValuableInt {
    
    // MARK: Implementation
    
    public static let maxLosslessSignificantDigits: Int = 3
}

// MARK: - Int16

extension Int16: ValuableInt {
    
    // MARK: Implementation
    
    public static let maxLosslessSignificantDigits: Int = 5
}

// MARK: - Int32

extension Int32: ValuableInt {
    
    // MARK: Implementation
    
    public static let maxLosslessSignificantDigits: Int = 10
}

// MARK: Int64

extension Int64: ValuableInt {
    
    // MARK: Implementation
    
    public static let maxLosslessSignificantDigits: Int = 19
}
