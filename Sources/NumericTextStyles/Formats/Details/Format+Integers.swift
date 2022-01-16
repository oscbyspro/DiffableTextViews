//
//  Format+Integers.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

import Foundation

//*============================================================================*
// MARK: * Integer
//*============================================================================*

extension IntegerFormatStyle: NumberFormat { }

//*============================================================================*
// MARK: * Integer x Currency
//*============================================================================*

extension IntegerFormatStyle.Currency: CurrencyFormat { }

//*============================================================================*
// MARK: * Integer x Percent
//*============================================================================*

extension IntegerFormatStyle.Percent: PercentFormat { }
