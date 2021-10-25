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
        Number.maxNumberOfDecimalDigits
    }
    
    // MARK: Components

    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        Number.init(components.characters())
    }
}

// MARK: - NumericTextSchemeOfIntegerSubject

public protocol NumericTextSchemeOfIntegerSubject: FixedWidthInteger {
    @inlinable init?(_ description: String)
    
    @inlinable static var maxNumberOfDecimalDigits: Int { get }
}

// MARK: - NumericTextIntegerSchemeOfSchematic

public protocol NumericTextSchemeOfIntegerSchematic: NumericTextSchematic, NumericTextSchemeOfIntegerSubject where NumericTextScheme == NumericTextSchemeOfInteger<Self> { }

// MARK: - Ints

extension Int: NumericTextSchemeOfIntegerSchematic {
    public static let maxNumberOfDecimalDigits: Int = String(max).count
}

extension Int8: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxNumberOfDecimalDigits: Int { 3 }
}

extension Int16: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxNumberOfDecimalDigits: Int { 5 }
}

extension Int32: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxNumberOfDecimalDigits: Int { 10 }
}

extension Int64: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxNumberOfDecimalDigits: Int { 19 }
}

// MARK: - UInts

extension UInt: NumericTextSchemeOfIntegerSchematic {
    public static let maxNumberOfDecimalDigits: Int = String(max).count
}

extension UInt8: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxNumberOfDecimalDigits: Int { 3 }
}

extension UInt32: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxNumberOfDecimalDigits: Int { 10 }
}

extension UInt16: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxNumberOfDecimalDigits: Int { 5 }
}

extension UInt64: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxNumberOfDecimalDigits: Int { 20 }
}
