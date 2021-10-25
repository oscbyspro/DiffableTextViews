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
/// - abs == 2 ^ (significandBitCount + 1)
/// - maxTotalDigits = String(describing: abs).count
public enum NumericTextSchemeFloat64: NumericTextFloatScheme {
    public typealias Number = Float64
    public typealias FormatStyle = FloatingPointFormatStyle<Number>
    
    // MARK: Values
    
    public static let abs: Number = 9007199254740992
    @inlinable public static var min: Double { -abs }
    @inlinable public static var max: Double {  abs }
    
    // MARK: Precision
    
    public static let maxTotalDigits: Int = 16

    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeFloat64.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeFloat64
}

