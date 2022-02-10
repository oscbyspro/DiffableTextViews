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

extension Decimal.FormatStyle: Plain { }
extension Decimal.FormatStyle.Currency: Currency { }
extension Decimal.FormatStyle.Percent: Percent { }

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format, Plain where FormatInput: FloatingPoint { }
extension FloatingPointFormatStyle.Currency: Format, Currency where FormatInput: FloatingPoint { }
extension FloatingPointFormatStyle.Percent: Format, Percent where FormatInput: FloatingPoint { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle: Format, Plain where FormatInput: Integer { }
extension IntegerFormatStyle.Currency: Format, Currency where FormatInput: Integer { }
