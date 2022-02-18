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

extension Decimal.FormatStyle: NumberFormat {
    public typealias Adapter = Standard<Self>
}

extension Decimal.FormatStyle.Currency: CurrencyFormat {
    public typealias Adapter = Currency<Self>
}

extension Decimal.FormatStyle.Percent: PercentFormat {
    public typealias Adapter = Percent<Self>
}

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format, NumberFormat where
FormatInput: NumericTextFloatingPointValue {
    public typealias Adapter = Standard<Self>
}

extension FloatingPointFormatStyle.Currency: Format, CurrencyFormat where
FormatInput: NumericTextFloatingPointValue {
    public typealias Adapter = Currency<Self>
}

extension FloatingPointFormatStyle.Percent: Format, PercentFormat where
FormatInput: NumericTextFloatingPointValue {
    public typealias Adapter = Percent<Self>
}

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle: Format, NumberFormat where
FormatInput: NumericTextIntegerValue {
    public typealias Adapter = Standard<Self>
}

extension IntegerFormatStyle.Currency: Format, CurrencyFormat where
FormatInput: NumericTextIntegerValue {
    public typealias Adapter = Currency<Self>
}
