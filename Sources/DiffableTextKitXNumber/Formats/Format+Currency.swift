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
// MARK: * Format x Currency
//*============================================================================*

extension      Decimal.FormatStyle.Currency: _Format & _Currency { }
extension FloatingPointFormatStyle.Currency: _Format & _Currency { }
extension       IntegerFormatStyle.Currency: _Format & _Currency { }
