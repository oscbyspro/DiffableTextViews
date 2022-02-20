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
// MARK: * Lexicon
//*============================================================================*

public final class Lexicon {
    @usableFromInline typealias Cache<Key: Localizable> = Support.Cache<Key, Lexicon>
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=
    
    @usableFromInline static private(set) var done = false
    @usableFromInline static let standard = Cache<StandardID>(size: 33)
    @usableFromInline static let currency = Cache<CurrencyID>(size: 33)

    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let USD = "USD"
    @usableFromInline static let en_US = Lexicon(
        locale: Locale(identifier: "en_US"),
        signs: .ascii(), digits: .ascii(), separators: .ascii()
    )
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let locale: Locale
    @usableFromInline let signs: Links<Sign>
    @usableFromInline let digits: Links<Digit>
    @usableFromInline let separators: Links<Separator>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale, signs: Links<Sign>, digits: Links<Digit>, separators: Links<Separator>) {
        self.locale = locale
        self.signs = signs
        self.digits = digits
        self.separators = separators
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializer - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable convenience init<Key: Localizable>(_ key: Key) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal; key.update(formatter)
        //=--------------------------------------=
        // MARK: Initialize
        //=--------------------------------------=
        self.init(locale: key.locale, signs:      key.links(formatter),
        digits: key.links(formatter), separators: key.links(formatter))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Cache
//=----------------------------------------------------------------------------=

extension Lexicon {

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func standard(locale: Locale) -> Lexicon {
        search(standard, key: StandardID(locale:  locale))
    }
    
    @inlinable static func currency(code: String, locale: Locale) -> Lexicon {
        search(currency, key: CurrencyID(locale:  locale, code: code))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=

    @inlinable static func setup() {
        guard !done else { return }; done = true
        standard[StandardID(locale: en_US.locale           )] = en_US
        currency[CurrencyID(locale: en_US.locale, code: USD)] = en_US
    }
    
    @inlinable static func search<Key: Localizable>(_ cache: Cache<Key>, key: Key) -> Lexicon {
        setup(); return cache.search(key, make: .init(key))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Parse
//=----------------------------------------------------------------------------=

extension Lexicon {

    //=------------------------------------------------------------------------=
    // MARK: Components -> Value
    //=------------------------------------------------------------------------=
    
    /// Relies on the fact that implemented styles can parse pure numbers.
    /// If this changes, then it should be remade to use pure number styles.
    @inlinable func value<F: Format>(of components: Components, as format: F) throws -> F.Value {
        try format.locale(Self.en_US.locale).parse(String(describing: components))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot -> Components
    //=------------------------------------------------------------------------=
    
    /// To use this method, all formatting characters must be marked as virtual.
    @inlinable func components<V: Value>(in snapshot: Snapshot, as value: V.Type) throws -> Components {
        let characters = snapshot.lazy.filter(\.nonvirtual).map(\.character)
        return try .init(characters: characters, integer: V.isInteger, unsigned: V.isUnsigned,
        signs: signs.components, digits: digits.components, separators: separators.components)
    }
}
