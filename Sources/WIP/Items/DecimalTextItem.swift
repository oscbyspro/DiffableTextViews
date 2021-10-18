//
//  DecimalTextItem.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import struct Foundation.Decimal

// MARK: - DecimalTextItem

enum DecimalTextItem: NumberTextValuesItem, NumberTextPrecisionItem {
    
    typealias Number = Decimal
    
    // MARK: Values
    
    public static let zero = Decimal.zero

    public static let min = -Decimal(string: String(repeating: "9", count: 38))!
    public static let max = +Decimal(string: String(repeating: "9", count: 38))!
    
    // MARK: Precision
    
    public static let precision: Int = 38
}

