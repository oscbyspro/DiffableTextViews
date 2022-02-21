//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation
import Support

//*============================================================================*
// MARK: * Currency
//*============================================================================*

final class NumericTextCurrencyAdapter: Adapter {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let label:   Label
    public let lexicon: Lexicon

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    #warning("It should cache.")
    @inlinable public init<Format: NumericTextCurrencyFormat>(_ format: Format) {
        self.lexicon = .currency(code: format.currencyCode, locale:  format.locale)
        self.label   = .currency(code: format.currencyCode, lexicon: lexicon)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable public func autocorrect(_ snapshot: inout Snapshot) {
        guard !label.characters.isEmpty else { return }
        guard let range = label.range(in: snapshot) else { return }
        snapshot.update(attributes: range) { attribute in attribute = .phantom }
    }
}


#warning("WIP")
#warning("WIP")
#warning("WIP")
#warning("Remove the ID part, maybe.")
//*============================================================================*
// MARK: * Currency x ID
//*============================================================================*

@usableFromInline final class CurrencyID: Hashable {
    
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
