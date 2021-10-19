//
//  DecimalTextItem.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import struct Foundation.Decimal

// MARK: - DecimalTextItem

enum DecimalTextItem: NumberTextPrecisionItem, NumberTextValuesItem {
    
    typealias Number = Decimal
    
    // MARK: Precision
 
    public static let maxTotalDigits: Int = 38
    public static let maxUpperDigits: Int = maxTotalDigits
    public static let maxLowerDigits: Int = maxTotalDigits
    
    // MARK: Values
    
    public static let zero = Decimal.zero
    public static let min = -Decimal(string: String(repeating: "9", count: maxTotalDigits))!
    public static let max = +Decimal(string: String(repeating: "9", count: maxTotalDigits))!
}
