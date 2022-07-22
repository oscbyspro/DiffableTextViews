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
// MARK: * Aliases
//*============================================================================*

public typealias NumberTextStyle<Value> = Value.NumberTextGraph.Number
where Value: _Value, Value.NumberTextGraph: _Numberable

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
