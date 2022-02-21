//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

#warning("Remove the ID part, maybe.")
//*============================================================================*
// MARK: * Currency x ID
//*============================================================================*

@usableFromInline final class CurrencyID: Localizable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let code:   String
    @usableFromInline let locale: Locale
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale, code: String) {
        self.code = code; self.locale = locale
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Hashable
    //=------------------------------------------------------------------------=
    
    @inlinable func hash(into hasher: inout Hasher) {
        hasher.combine(code); hasher.combine(locale.identifier)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: CurrencyID, rhs: CurrencyID) -> Bool {
        lhs.code == rhs.code && lhs.locale.identifier == rhs.locale.identifier
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension CurrencyID {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable func update(_ formatter: NumberFormatter) {
        formatter.locale = locale
        formatter.currencyCode = code
    }
 
    @inlinable func links<T: Component>(_ formatter: NumberFormatter) -> Links<T> {
        .currency(formatter)
    }
}
