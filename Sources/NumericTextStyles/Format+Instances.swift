//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Format x Decimal
//*============================================================================*

extension Decimal.FormatStyle: Formats.Number {
    public typealias NumericTextAdapter = NumericTextNumberAdapter<Self>
}

extension Decimal.FormatStyle.Currency: Formats.Currency {
    public typealias NumericTextAdapter = NumericTextCurrencyAdapter<Self>
}

extension Decimal.FormatStyle.Percent: Formats.Percent {
    public typealias NumericTextAdapter = NumericTextPercentAdapter<Self>
}

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format, Formats.Number where
FormatInput: NumericTextFloatingPointValue {
    public typealias NumericTextAdapter = NumericTextNumberAdapter<Self>
}

extension FloatingPointFormatStyle.Currency: Format, Formats.Currency where
FormatInput: NumericTextFloatingPointValue {
    public typealias NumericTextAdapter = NumericTextCurrencyAdapter<Self>
}

extension FloatingPointFormatStyle.Percent: Format, Formats.Percent where
FormatInput: NumericTextFloatingPointValue {
    public typealias NumericTextAdapter = NumericTextPercentAdapter<Self>
}

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle: Format, Formats.Number where
FormatInput: NumericTextIntegerValue {
    public typealias NumericTextAdapter = NumericTextNumberAdapter<Self>
}

extension IntegerFormatStyle.Currency: Format, Formats.Currency where
FormatInput: NumericTextIntegerValue {
    public typealias NumericTextAdapter = NumericTextCurrencyAdapter<Self>
}
