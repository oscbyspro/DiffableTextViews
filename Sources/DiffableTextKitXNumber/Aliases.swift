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
// MARK: * Aliases x Public
//*============================================================================*

public typealias NumberTextStyle<Value> =
Value.NumberTextGraph.Number where
Value.NumberTextGraph: _Numberable, Value: _Value

public typealias NumberTextBounds<Value> =
_Bounds<Value> where Value: _Input

public typealias NumberTextPrecision<Value> =
_Precision<Value> where Value: _Input

//*============================================================================*
// MARK: * Aliases x Internal
//*============================================================================*

public typealias _FPRR = FloatingPointRoundingRule

public typealias _NFSC =   NumberFormatStyleConfiguration
public typealias _CFSC = CurrencyFormatStyleConfiguration

public typealias _NFSC_SignDS = _NFSC.SignDisplayStrategy
public typealias _CFSC_SignDS = _CFSC.SignDisplayStrategy

public typealias _NFSC_SeparatorDS = _NFSC.DecimalSeparatorDisplayStrategy
public typealias _CFSC_SeparatorDS = _CFSC.DecimalSeparatorDisplayStrategy
