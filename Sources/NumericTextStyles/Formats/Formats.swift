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
FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Currency:
Format, CurrencyFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Percent:
Format, PercentFormat where
FormatInput: NumericTextStyles.FloatingPointValue { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle:
Format, NumberFormat where
FormatInput: NumericTextStyles.IntegerValue { }

extension IntegerFormatStyle.Currency:
Format, CurrencyFormat where
FormatInput: NumericTextStyles.IntegerValue { }
