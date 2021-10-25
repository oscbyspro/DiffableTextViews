//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.FloatingPointFormatStyle

// MARK: - NumericTextSchemeFloat

/// NumericTextSchemeFloat16.
///
/// - Supports up to 4 decimal digits and values of ±2,048.
public enum NumericTextSchemeFloat16: NumericTextFloatScheme {
    public typealias Number = Float16
    public typealias FormatStyle = FloatingPointFormatStyle<Number>
    
    // MARK: Values
        
    @inlinable public static var abs: Number { 2048 }
    @inlinable public static var min: Number { -abs }
    @inlinable public static var max: Number {  abs }

    // MARK: Precision
    
    @inlinable public static var maxTotalDigits: Int { 4 }

    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeFloat16.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeFloat16
}


