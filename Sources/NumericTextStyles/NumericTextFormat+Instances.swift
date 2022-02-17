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

extension Decimal.FormatStyle: _Number { }
extension Decimal.FormatStyle.Currency: _Currency { }
extension Decimal.FormatStyle.Percent: _Percent { }

//*============================================================================*
// MARK: * Format x Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format, _Number where FormatInput: FloatingPoint { }
extension FloatingPointFormatStyle.Currency: Format, _Currency where FormatInput: FloatingPoint { }
extension FloatingPointFormatStyle.Percent: Format, _Percent where FormatInput: FloatingPoint { }

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle: Format, _Number where FormatInput: Integer { }
extension IntegerFormatStyle.Currency: Format, _Currency where FormatInput: Integer { }
