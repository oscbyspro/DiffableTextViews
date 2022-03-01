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
// MARK: * Translation x Currency
//*============================================================================*

@usableFromInline final class NumericTextTranslation_Currency: Translations.Reuseable {
    @usableFromInline static let cache = Cache<ID, NumericTextTranslation_Currency>(33)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let label:   Label
    @usableFromInline let lexicon: Lexicon

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ key: ID) {
        self.lexicon = .currency(key.locale, code: key.code)
        self.label   = .currency(lexicon,    code: key.code)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func reuseable<T>(_ format: T) -> Self where T: Formats.Currency {
        reuseable(ID(format.locale, format.currencyCode))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) {
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
        
        @inlinable init(_ locale: Locale, _ code: String) {
            self.locale = locale; self.code = code
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Hashable
        //=--------------------------------------------------------------------=
        
        @inlinable func hash(into hasher: inout Hasher) {
            hasher.combine(locale); hasher.combine(code)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=
        
        @inlinable static func == (lhs: ID, rhs: ID) -> Bool {
            lhs.locale == rhs.locale && lhs.code == rhs.code
        }
    }
}
