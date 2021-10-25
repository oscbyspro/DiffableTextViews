//
//  NumericTextSchemeUInt.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.IntegerFormatStyle

// MARK: - NumericTextSchemeUInt

public enum NumericTextSchemeUInt: NumericTextIntegerScheme {
    public typealias Number = UInt
    public typealias FormatStyle = IntegerFormatStyle<Number>
    
    // MARK: Precision
    
    public static let maxTotalDigits: Int = String(describing: max).count
    
    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeUInt.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeUInt
}
