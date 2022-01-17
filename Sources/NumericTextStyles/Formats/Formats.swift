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

extension FloatingPointFormatStyle: NumberFormat { }
extension FloatingPointFormatStyle.Currency: CurrencyFormat { }
extension FloatingPointFormatStyle.Percent: PercentFormat { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle: NumberFormat { }
extension IntegerFormatStyle.Currency: CurrencyFormat { }
extension IntegerFormatStyle.Percent: PercentFormat { }
