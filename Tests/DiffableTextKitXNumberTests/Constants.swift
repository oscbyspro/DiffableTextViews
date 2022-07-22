//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKitXNumber

import Foundation

//*============================================================================*
// MARK: * Constants
//*============================================================================*

let USD: String = "USD"

let en_US: Locale = Locale(identifier: "en_US")

let currencyCodes: [String] = Locale
    .isoCurrencyCodes

let locales: [Locale] = Locale
    .availableIdentifiers.lazy.map(Locale.init)
    .sorted(by: { $0.identifier < $1.identifier })

let numbers: [(style: Standard, cache: Standard.Cache)] = locales
    .lazy.map(NumberTextStyle<Decimal>.init).map({($0, $0.cache())})

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

typealias Standard = NumberTextStyle<Decimal>
