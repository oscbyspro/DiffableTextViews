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
// MARK: * Currency x ID
//*============================================================================*

@usableFromInline final class CurrencyID: Hashable {
    
    //=--------------------------------------------------------------------=
    // MARK: State
    //=--------------------------------------------------------------------=
    
    @usableFromInline let code:   String
    @usableFromInline let locale: String
    
    //=--------------------------------------------------------------------=
    // MARK: Initializers
    //=--------------------------------------------------------------------=
    
    @inlinable init(code: String, locale: Locale) {
        self.code = code; self.locale = locale.identifier
    }
    
    @inlinable init(locale: Locale, code: String) {
        self.code = code; self.locale = locale.identifier
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Hashable
    //=--------------------------------------------------------------------=
    
    @inlinable func hash(into hasher: inout Hasher) {
        hasher.combine(code); hasher.combine(locale)
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Comparisons
    //=--------------------------------------------------------------------=
    
    @inlinable static func == (lhs: CurrencyID, rhs: CurrencyID) -> Bool {
        lhs.code == rhs.code && lhs.locale == rhs.locale
    }
}
