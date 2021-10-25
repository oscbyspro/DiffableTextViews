//
//  NumericTextSchemeIntegers.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.IntegerFormatStyle

// MARK: - NumericTextSchemeOfInteger

/// NumericTextSchemeOfInteger.
///
/// - Supports all values between Number.min and Number.max.
public struct NumericTextSchemeOfInteger<Number: NumericTextSchemeOfIntegerSubject>: NumericTextIntegerScheme {
    public typealias FormatStyle = IntegerFormatStyle<Number>
    
    // MARK: Precision
    
    @inlinable public static var maxTotalDigits: Int {
        Number.maxSignificands
    }
    
    // MARK: Components

    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        Number.init(components.characters())
    }
}

// MARK: - NumericTextSchemeOfIntegerSubject

public protocol NumericTextSchemeOfIntegerSubject: FixedWidthInteger {
    @inlinable init?(_ description: String)
    
    @inlinable static var maxSignificands: Int { get }
}

// MARK: - NumericTextIntegerSchemeOfSchematic

public protocol NumericTextSchemeOfIntegerSchematic: NumericTextSchematic, NumericTextSchemeOfIntegerSubject where NumericTextScheme == NumericTextSchemeOfInteger<Self> { }

// MARK: - Ints

extension Int: NumericTextSchemeOfIntegerSchematic {
    public static let maxSignificands: Int = String(max).count
}

extension Int8: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 3 }
}

extension Int16: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 5 }
}

extension Int32: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 10 }
}

extension Int64: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 19 }
}

// MARK: - UInts

extension UInt: NumericTextSchemeOfIntegerSchematic {
    /// Issue: IntegerFormatStyle[UInt64] only supports 18 digits rather than 19.
    public static let maxSignificands: Int = Swift.min(String(max).count, UInt64.maxSignificands)
}

extension UInt8: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 3 }
}

extension UInt16: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 5 }
}

extension UInt32: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 10 }
}

extension UInt64: NumericTextSchemeOfIntegerSchematic {
    /// Issue: IntegerFormatStyle[UInt64] only supports 18 digits rather than 19.
    /// - It probably means that Apple uses an Int64, rather than a UInt64. Sad.
    @inlinable public static var maxSignificands: Int { 18 }
}
