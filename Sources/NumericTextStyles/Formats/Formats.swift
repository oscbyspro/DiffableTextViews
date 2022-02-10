//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Format x Decimal
//*============================================================================*

extension Decimal.FormatStyle:
Standard { }

extension Decimal.FormatStyle.Currency:
Currency { }

extension Decimal.FormatStyle.Percent:
Percent { }

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle:
NumericTextFormat, Standard where
FormatInput: FloatingPoint { }

extension FloatingPointFormatStyle.Currency:
NumericTextFormat, Currency where
FormatInput: FloatingPoint { }

extension FloatingPointFormatStyle.Percent:
NumericTextFormat, Percent where
FormatInput: FloatingPoint { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle:
NumericTextFormat, Standard where
FormatInput: Integer { }

extension IntegerFormatStyle.Currency:
NumericTextFormat, Currency where
FormatInput: Integer { }
