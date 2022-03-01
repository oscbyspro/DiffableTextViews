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
// MARK: * Style x Initializers
//*============================================================================*

extension NumericTextStyle where Format: NumericTextFormat_Number {
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.init(Format(locale: locale))
    }
}

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Decimal> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Double
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Double> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int8> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int16> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int32> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * Int64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int64> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt8> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt16> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt32> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt64> {
    @inlinable public static var number: Self {
        Self(.number)
    }
}
