//
//  Formats.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension Decimal.FormatStyle: Format { }

//*============================================================================*
// MARK: * Decimal x Currency
//*============================================================================*

extension Decimal.FormatStyle.Currency: Format { }

//*============================================================================*
// MARK: * Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format { }

//*============================================================================*
// MARK: * Floating Point x Currency
//*============================================================================*

extension FloatingPointFormatStyle.Currency: Format { }

//*============================================================================*
// MARK: * Integer
//*============================================================================*

extension IntegerFormatStyle: Format { }

//*============================================================================*
// MARK: * Integer x Currency
//*============================================================================*

extension IntegerFormatStyle.Currency: Format { }
