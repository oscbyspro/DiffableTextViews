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
// MARK: * Aliases x Style
//*============================================================================*

public typealias _WIP_NumberTextStyle<Value: _Value> = Value.NumberTextStyle

//=----------------------------------------------------------------------------=
// MARK: + Branches
//=----------------------------------------------------------------------------=

public extension _DefaultStyle where Graph.Format: _Format_Percentable {
    typealias Percent = _DefaultStyle<Graph.Percent>
}

public extension _DefaultStyle where Graph.Format: _Format_Currencyable {
    typealias Currency = _DefaultStyle<Graph.Currency>
}

//=----------------------------------------------------------------------------=
// MARK: + Branches x Optional
//=----------------------------------------------------------------------------=

public extension _DefaultStyle.Optional where Graph.Format: _Format_Percentable {
    typealias Percent = _DefaultStyle<Graph.Percent>.Optional
}

public extension _DefaultStyle.Optional where Graph.Format: _Format_Currencyable {
    typealias Currency = _DefaultStyle<Graph.Currency>.Optional
}

//*============================================================================*
// MARK: * Aliases x Convenience
//*============================================================================*

public typealias _NFSC = NumberFormatStyleConfiguration
public typealias _CFSC = CurrencyFormatStyleConfiguration

public typealias _NFSC_SignDS = _NFSC.SignDisplayStrategy
public typealias _NFSC_SeparatorDS = _NFSC.DecimalSeparatorDisplayStrategy

public typealias _CFSC_SignDS = _CFSC.SignDisplayStrategy
public typealias _CFSC_SeparatorDS = _CFSC.DecimalSeparatorDisplayStrategy

public typealias _FPRR = FloatingPointRoundingRule
