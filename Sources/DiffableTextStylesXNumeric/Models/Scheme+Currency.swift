//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Scheme x Currency
//*============================================================================*

@usableFromInline final class NumericTextSchemeXCurrency: Schemes.Reuseable {
    @usableFromInline static let cache = Cache<ID, NumericTextSchemeXCurrency>(33)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let id: ID
    @usableFromInline let label: Label
    @usableFromInline let lexicon: Lexicon
    @usableFromInline let preferences: Preferences

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ id: ID) {
        let formatter = NumberFormatter()
        formatter.locale = id.locale
        formatter.currencyCode = id.code
        assert(formatter.numberStyle == .none)
        //=--------------------------------------=
        // MARK: Instantiate
        //=--------------------------------------=
        self.id = id
        //=--------------------------------------=
        // MARK: Instantiate: Style == None
        //=--------------------------------------=
        self.lexicon = .currency(formatter)
        self.label   = .currency(id.locale, code: id.code, lexicon: lexicon)
        //=--------------------------------------=
        // MARK: Instantiate: Style == Currency
        //=--------------------------------------=
        formatter.numberStyle = .currency
        self.preferences = Preferences(formatter)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func reuse<T>(_ format: T) -> Self where T: Formats.Currency {
        reuse(ID(format.locale, format.currencyCode))
    }
    
    //*========================================================================*
    // MARK: * ID
    //*========================================================================*

    @usableFromInline struct ID: Hashable {
        
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
    }
    
    //*========================================================================*
    // MARK: * Preferences
    //*========================================================================*
    
    @usableFromInline struct Preferences {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let fraction: ClosedRange<Int>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ formatter: NumberFormatter) {
            self.fraction =
            formatter.minimumFractionDigits ...
            formatter.maximumFractionDigits
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Specialization
//=----------------------------------------------------------------------------=

extension NumericTextSchemeXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<T>(_ value: T.Type) -> Precision<T> where T: Value {
        Precision(fraction: preferences.fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) {
        guard !label.characters.isEmpty else { return }
        guard let indices = label.indices(in: snapshot) else { return }
        snapshot.update(attributes: indices) { attribute in attribute = .phantom }
    }
}
