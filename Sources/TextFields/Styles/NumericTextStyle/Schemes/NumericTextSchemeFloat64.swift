//
//  NumericTextSchemeFloat64.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.FloatingPointFormatStyle

// MARK: - NumericTextSchemeFloat64

/// NumericTextSchemeFloat64.
///
/// - Supports up to 15 decimal digits: ±9,007,199,254,740,992 (rounded towards zero).
public enum NumericTextSchemeFloat64: NumericTextFloatScheme {
    public typealias Number = Float64
    public typealias FormatStyle = FloatingPointFormatStyle<Number>
    
    // MARK: Values
    
    @inlinable public static var abs: Number { 9007199254740992 }
    @inlinable public static var min: Number { -abs }
    @inlinable public static var max: Number {  abs }
    
    // MARK: Precision
    
    public static let maxTotalDigits: Int = 15

    // MARK: Components

    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeFloat64.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeFloat64
}

