//
//  Format+Decimals.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension Decimal.FormatStyle: NumberFormat { }

//*============================================================================*
// MARK: * Decimal x Currency
//*============================================================================*

extension Decimal.FormatStyle.Currency: CurrencyFormat { }

//*============================================================================*
// MARK: * Integer x Percent
//*============================================================================*

extension Decimal.FormatStyle.Percent: PercentFormat { }
