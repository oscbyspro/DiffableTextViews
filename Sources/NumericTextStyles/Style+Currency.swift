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
// MARK: * Decimal
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Float16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>.Currency> {
    //=------------------------------------------=
    // MARK: Internal - Inaccurate Format Style
    //=------------------------------------------=
    @inlinable internal static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Float32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>.Currency> {
    //=------------------------------------------=
    // MARK: Internal - Inaccurate Format Style
    //=------------------------------------------=
    @inlinable internal static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Float64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Int8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Int16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Int32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Int64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>.Currency> {
    @inlinable public static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}