//
//  Format+FloatingPoints.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

import Foundation

//*============================================================================*
// MARK: * Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: NumberFormat { }

//*============================================================================*
// MARK: * Floating Point x Currency
//*============================================================================*

extension FloatingPointFormatStyle.Currency: CurrencyFormat { }


//*============================================================================*
// MARK: * Floating Point x Percent
//*============================================================================*

extension FloatingPointFormatStyle.Percent: PercentFormat { }

