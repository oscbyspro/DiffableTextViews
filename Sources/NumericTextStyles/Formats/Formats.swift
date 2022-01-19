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

extension Decimal.FormatStyle: NumberFormat { }
extension Decimal.FormatStyle.Currency: CurrencyFormat { }
extension Decimal.FormatStyle.Percent: PercentFormat { }

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format       where FormatInput: NumericTextStyles.FloatingPointValue { }
extension FloatingPointFormatStyle: NumberFormat where FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Currency: Format         where FormatInput: NumericTextStyles.FloatingPointValue { }
extension FloatingPointFormatStyle.Currency: CurrencyFormat where FormatInput: NumericTextStyles.FloatingPointValue { }

extension FloatingPointFormatStyle.Percent: Format        where FormatInput: NumericTextStyles.FloatingPointValue { }
extension FloatingPointFormatStyle.Percent: PercentFormat where FormatInput: NumericTextStyles.FloatingPointValue { }

//*============================================================================*
// MARK: * Format x Integer (Percent Is Disallowed)
//*============================================================================*

extension IntegerFormatStyle: Format       where FormatInput: NumericTextStyles.IntegerValue { }
extension IntegerFormatStyle: NumberFormat where FormatInput: NumericTextStyles.IntegerValue { }

extension IntegerFormatStyle.Currency: Format         where FormatInput: NumericTextStyles.IntegerValue { }
extension IntegerFormatStyle.Currency: CurrencyFormat where FormatInput: NumericTextStyles.IntegerValue { }
