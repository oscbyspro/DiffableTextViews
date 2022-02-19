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

extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Float16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Float32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Float64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}
