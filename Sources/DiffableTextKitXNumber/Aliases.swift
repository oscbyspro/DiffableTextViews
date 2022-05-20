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
// MARK: Declaration
//*============================================================================*

public typealias NumberTextStyle<Kind: NumberTextKind> = Kind.NumberTextStyle

//*============================================================================*
// MARK: Standard
//*============================================================================*

extension _NumberTextStyle where Format: NumberTextFormatXCurrencyable {
    public typealias Currency = _NumberTextStyle<Format.Currency>
}

extension _NumberTextStyle where Format: NumberTextFormatXPercentable {
    public typealias Percent = _NumberTextStyle<Format.Percent>
}

//*============================================================================*
// MARK: Optional
//*============================================================================*

extension _OptionalNumberTextStyle where Format: NumberTextFormatXCurrencyable {
    public typealias Currency = _OptionalNumberTextStyle<Format.Currency>
}

extension _OptionalNumberTextStyle where Format: NumberTextFormatXPercentable {
    public typealias Percent = _OptionalNumberTextStyle<Format.Percent>
}

//*============================================================================*
// MARK: Helpers
//*============================================================================*

public typealias NFSC =   NumberFormatStyleConfiguration
public typealias CFSC = CurrencyFormatStyleConfiguration
