//
//  NumericTextSchemeFloat64.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.Locale
import struct Foundation.FloatingPointFormatStyle

// MARK: - NumericTextSchemeFloat64

public enum NumericTextSchemeFloat64: NumericTextFloatScheme {
    public typealias Number = Float64
    public typealias Style = FloatingPointFormatStyle<Number>
    
    // MARK: Precision
    
    public static let maxTotalDigits: Int = 15
    
    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeFloat64.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeFloat64
}

