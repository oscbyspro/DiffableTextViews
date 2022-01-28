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
NumberFormat, RoundableByIncrementFormat { }

extension Decimal.FormatStyle.Currency:
CurrencyFormat, RoundableByIncrementFormat { }

extension Decimal.FormatStyle.Percent:
PercentFormat, RoundableByIncrementFormat { }

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle:
Format, NumberFormat, RoundableByIncrementFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Currency:
Format, CurrencyFormat, RoundableByIncrementFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Percent:
Format, PercentFormat, RoundableByIncrementFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle:
Format, NumberFormat, RoundableByIncrementFormat where
FormatInput: NumericTextStyles.IntegerValue { }

extension IntegerFormatStyle.Currency:
Format, CurrencyFormat, RoundableByIncrementFormat where
FormatInput: NumericTextStyles.IntegerValue { }
