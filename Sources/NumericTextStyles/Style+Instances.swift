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

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle.Percent> {
    @inlinable static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Floats - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>.Percent> {
    @inlinable static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Floats - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>.Percent> {
    @inlinable static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Floats - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>.Percent> {
    @inlinable static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Ints
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints - 8
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * Ints - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts - 8
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}

//*============================================================================*
// MARK: * UInts - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>> {
    @inlinable static var number: Self {
        Self(.number)
    }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>.Currency> {
    @inlinable static func currency(code: String) -> Self {
        Self(.currency(code: code))
    }
}
