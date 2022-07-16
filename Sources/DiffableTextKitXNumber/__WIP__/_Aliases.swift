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
// MARK: * Style x Aliases
//*============================================================================*

public typealias _WIP_NumberTextStyle<Kind: _Kind> = Kind.NumberTextStyle

//=----------------------------------------------------------------------------=
// MARK: + Standard
//=----------------------------------------------------------------------------=

public extension _Style where Format: _Format_Percentable {
    typealias Percent = _Style<_StandardID<Format.Percent>>
}

public extension _Style where Format: _Format_Currencyable {
    typealias Currency = _Style<_CurrencyID<Format.Currency>>
}

//=----------------------------------------------------------------------------=
// MARK: + Optional
//=----------------------------------------------------------------------------=

public extension _Optional where Format: _Format_Percentable {
    typealias Percent = _Optional<_StandardID<Format.Percent>>
}

public extension _Optional where Format: _Format_Currencyable {
    typealias Currency = _Optional<_CurrencyID<Format.Currency>>
}
