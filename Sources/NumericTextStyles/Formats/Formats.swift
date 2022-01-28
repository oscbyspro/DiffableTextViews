//
//  Formats.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-17.
//

import Foundation

//*============================================================================*
// MARK: * Format x Decimal
//*============================================================================*

extension Decimal.FormatStyle:
NumberFormat, RoundableByIntFormat { }

extension Decimal.FormatStyle.Currency:
CurrencyFormat, RoundableByIntFormat { }

extension Decimal.FormatStyle.Percent:
PercentFormat, RoundableByIntFormat { }

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle:
Format, NumberFormat, RoundableByDoubleFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Currency:
Format, CurrencyFormat, RoundableByDoubleFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Percent:
Format, PercentFormat, RoundableByDoubleFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle:
Format, NumberFormat, RoundableByIntFormat where
FormatInput: NumericTextStyles.IntegerValue { }

extension IntegerFormatStyle.Currency:
Format, CurrencyFormat, RoundableByIntFormat where
FormatInput: NumericTextStyles.IntegerValue { }
