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
// MARK: * Lexicons
//*============================================================================*

final class Lexicons {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    private(set) var standard: [Lexicon] = []
    private(set) var currency: [Lexicon] = []
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ locales: [Locale])  {
        //=--------------------------------------=
        // MARK: Standard
        //=--------------------------------------=
        self.standard = locales.compactMap {
            try? Lexicon._standard(locale: $0)
        }
        //=--------------------------------------=
        // MARK: Currency
        //=--------------------------------------=
        for locale in locales {
            for currency in currencies {
                if let lexicon = try? Lexicon._currency(code: currency, locale: locale) {
                    self.currency.append(lexicon)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func forEach(_ perform: (Lexicon) throws -> Void) rethrows {
        try standard.forEach(perform)
        try currency.forEach(perform)
    }
}

#endif
