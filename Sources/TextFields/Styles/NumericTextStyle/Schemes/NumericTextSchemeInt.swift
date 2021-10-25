//
//  NumericTextSchemeInt.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import struct Foundation.IntegerFormatStyle

// MARK: - NumericTextSchemeInt

public enum NumericTextSchemeInt: NumericTextIntegerScheme {
    public typealias Number = Int
    public typealias Style = IntegerFormatStyle<Number>
    
    // MARK: Precision
    
    public static let maxTotalDigits: Int = String(describing: max).count
    
    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeInt.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeInt
}
