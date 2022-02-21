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

#warning("Could probably be opaquely used.")
@usableFromInline final class Currency: Adapter {
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let cache = Cache<ID, Currency>(size: 33)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let label:   Label
    public let lexicon: Lexicon

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<Format: NumericTextCurrencyFormat>(_ format: Format) {
        self.lexicon = .currency(code: format.currencyCode, locale:  format.locale)
        self.label   = .currency(code: format.currencyCode, lexicon: lexicon)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func currency<Format: NumericTextCurrencyFormat>(_ format: Format) -> Currency {
        cache.search(ID(locale: format.locale, code: format.currencyCode), make: Self(format))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable public func autocorrect(_ snapshot: inout Snapshot) {
        guard !label.characters.isEmpty else { return }
        guard let range = label.range(in: snapshot) else { return }
        snapshot.update(attributes: range) { attribute in attribute = .phantom }
    }
    
    //*========================================================================*
    // MARK: * ID
    //*========================================================================*

    @usableFromInline final class ID: Hashable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let code:   String
        @usableFromInline let locale: Locale
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(locale: Locale, code: String) {
            self.code   = code
            self.locale = locale
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Hashable
        //=--------------------------------------------------------------------=
        
        @inlinable func hash(into hasher: inout Hasher) {
            hasher.combine(code)
            hasher.combine(locale.identifier)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=
        
        @inlinable static func == (lhs: ID, rhs: ID) -> Bool {
            lhs.code == rhs.code && lhs.locale.identifier == rhs.locale.identifier
        }
    }
}
