//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Foundation
@testable import NumericTextStyles

//*============================================================================*
// MARK: * Earth
//*============================================================================*

enum Earth {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=

    static let USD = "USD"
    
    static let en_US = Locale(identifier: "en_US")
    
    //=------------------------------------------------------------------------=
    // MARK: Collections
    //=------------------------------------------------------------------------=
        
    static let locales: [Locale] = Locale
        .availableIdentifiers.lazy.map(Locale.init)
        .sorted(by: { $0.identifier < $1.identifier })

    static let currencies: [String] = locales
        .lazy.compactMap(\.currencyCode)
        .reduce(into: Set()) { $0.insert($1) }
        .lazy.map({ $0 }).sorted(by: <)
 
    static let standard: [Lexicon] = locales
        .compactMap({ Lexicon._standard(in: $0) })
}

//*============================================================================*
// MARK: * Global
//*============================================================================*

var USD: String {
    Earth.USD
}

var en_US: Locale {
    Earth.en_US
}

var locales: [Locale] {
    Earth.locales
}

var currencies: [String] {
    Earth.currencies
}

var standard: [Lexicon] {
    Earth.standard
}

#endif
