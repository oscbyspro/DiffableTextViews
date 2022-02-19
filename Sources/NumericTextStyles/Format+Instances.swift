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

extension Decimal.FormatStyle: Format.Number {
    public typealias NumericTextAdapter = NumericTextNumberAdapter<Self>
}

extension Decimal.FormatStyle.Currency: Format.Currency {
    public typealias NumericTextAdapter = NumericTextCurrencyAdapter<Self>
}

extension Decimal.FormatStyle.Percent: Format.Percent {
    public typealias NumericTextAdapter = NumericTextPercentAdapter<Self>
}

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format, Format.Number where
FormatInput: NumericTextFloatValue {
    public typealias NumericTextAdapter = NumericTextNumberAdapter<Self>
}

extension FloatingPointFormatStyle.Currency: Format, Format.Currency where
FormatInput: NumericTextFloatValue {
    public typealias NumericTextAdapter = NumericTextCurrencyAdapter<Self>
}

extension FloatingPointFormatStyle.Percent: Format, Format.Percent where
FormatInput: NumericTextFloatValue {
    public typealias NumericTextAdapter = NumericTextPercentAdapter<Self>
}

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle: Format, Format.Number where
FormatInput: NumericTextIntegerValue {
    public typealias NumericTextAdapter = NumericTextNumberAdapter<Self>
}

extension IntegerFormatStyle.Currency: Format, Format.Currency where
FormatInput: NumericTextIntegerValue {
    public typealias NumericTextAdapter = NumericTextCurrencyAdapter<Self>
}
