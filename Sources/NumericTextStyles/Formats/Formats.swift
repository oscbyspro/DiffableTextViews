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

extension Decimal.FormatStyle:
NumberFormat { }

extension Decimal.FormatStyle.Currency:
CurrencyFormat { }

extension Decimal.FormatStyle.Percent:
PercentFormat { }

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle:
Format, NumberFormat where
FormatInput: FloatingPointNumericTextValue { }

extension FloatingPointFormatStyle.Currency:
Format, CurrencyFormat where
FormatInput: FloatingPointNumericTextValue { }

extension FloatingPointFormatStyle.Percent:
Format, PercentFormat where
FormatInput: FloatingPointNumericTextValue { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle:
Format, NumberFormat where
FormatInput: IntegerNumericTextValue { }

extension IntegerFormatStyle.Currency:
Format, CurrencyFormat where
FormatInput: IntegerNumericTextValue { }
