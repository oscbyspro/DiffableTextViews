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
NumberFormat, IntIncrementableFormat { }

extension Decimal.FormatStyle.Currency:
CurrencyFormat, IntIncrementableFormat { }

extension Decimal.FormatStyle.Percent:
PercentFormat, IntIncrementableFormat { }

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle:
Format, NumberFormat, DoubleIncrementableFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Currency:
Format, CurrencyFormat, DoubleIncrementableFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Percent:
Format, PercentFormat, DoubleIncrementableFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

//*============================================================================*
// MARK: * Format x Integer (Percent Is Disallowed)
//*============================================================================*

extension IntegerFormatStyle:
Format, NumberFormat, IntIncrementableFormat where
FormatInput: NumericTextStyles.IntegerValue { }

extension IntegerFormatStyle.Currency:
Format, CurrencyFormat, IntIncrementableFormat where
FormatInput: NumericTextStyles.IntegerValue { }
