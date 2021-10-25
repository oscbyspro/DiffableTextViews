//
//  NumericTextSchemeFloat64.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.FloatingPointFormatStyle

// MARK: - NumericTextSchemeFloat

/// NumericTextSchemeFloat32.
///
/// - Supports up to 8 decimal digits and values of ±16,777,216.
public enum NumericTextSchemeFloat32: NumericTextFloatScheme {
    public typealias Number = Float32
    public typealias FormatStyle = FloatingPointFormatStyle<Number>
    
    // MARK: Values
        
    @inlinable public static var abs: Number { 16777216 }
    @inlinable public static var min: Number { -abs }
    @inlinable public static var max: Number {  abs }

    // MARK: Precision
    
    @inlinable public static var maxTotalDigits: Int { 8 }

    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeFloat32.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeFloat32
}


