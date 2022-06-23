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
// MARK: * Constants
//*============================================================================*

enum Constants {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let currencies: [String] = Locale
        .isoCurrencyCodes
    
    static let locales: [Locale] = Locale
        .availableIdentifiers
        .lazy.map(Locale.init)
        .reduce(into: Set()) { $0.insert($1) }
        .sorted(by: { $0.identifier < $1.identifier })
}
