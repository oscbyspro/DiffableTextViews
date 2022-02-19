//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * Decimals
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle.Percent> {
    @inlinable public static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Floats - 16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}


extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>.Percent> {
    //=----------------------------------------------=
    // MARK: Internal - Inaccurate Format Style
    //=----------------------------------------------=
    @inlinable internal static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Floats - 32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>.Percent> {
    //=----------------------------------------------=
    // MARK: Internal - Inaccurate Format Style
    //=----------------------------------------------=
    @inlinable internal static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Floats - 64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>.Percent> {
    @inlinable public static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Ints
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints - 8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints - 16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints - 32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints - 64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts - 8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts - 16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts - 32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts - 64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}
