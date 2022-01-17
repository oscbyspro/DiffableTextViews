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

extension FloatingPointFormatStyle: Format       where FormatInput: NumericTextStyles.Value { }
extension FloatingPointFormatStyle: NumberFormat where FormatInput: NumericTextStyles.Value { }

extension FloatingPointFormatStyle.Currency: Format         where FormatInput: NumericTextStyles.Value { }
extension FloatingPointFormatStyle.Currency: CurrencyFormat where FormatInput: NumericTextStyles.Value { }

extension FloatingPointFormatStyle.Percent: Format        where FormatInput: NumericTextStyles.Value { }
extension FloatingPointFormatStyle.Percent: PercentFormat where FormatInput: NumericTextStyles.Value { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle: Format       where FormatInput: NumericTextStyles.Value { }
extension IntegerFormatStyle: NumberFormat where FormatInput: NumericTextStyles.Value { }

extension IntegerFormatStyle.Currency: Format         where FormatInput: NumericTextStyles.Value { }
extension IntegerFormatStyle.Currency: CurrencyFormat where FormatInput: NumericTextStyles.Value { }

extension IntegerFormatStyle.Percent: Format        where FormatInput: NumericTextStyles.Value { }
extension IntegerFormatStyle.Percent: PercentFormat where FormatInput: NumericTextStyles.Value { }
