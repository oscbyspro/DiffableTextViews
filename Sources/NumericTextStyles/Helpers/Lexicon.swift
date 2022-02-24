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

    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
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
    // MARK: Initializer - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func standard(_ locale: Locale) -> Lexicon {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        //=--------------------------------------=
        // MARK: Instantiate
        //=--------------------------------------=
        return  .init(locale: locale, signs:      .standard(formatter),
        digits: .standard(formatter), separators: .standard(formatter))
    }
    
    @inlinable static func currency(_ locale: Locale, code: String) -> Lexicon {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.currencyCode = code
        //=--------------------------------------=
        // MARK: Instantiate
        //=--------------------------------------=
        return  .init(locale: locale, signs:      .currency(formatter),
        digits: .currency(formatter), separators: .currency(formatter))
    }

    //=------------------------------------------------------------------------=
    // MARK: Components -> Value
    //=------------------------------------------------------------------------=
    
    /// Relies on the fact that implemented styles can parse unformatted numbers.
    @inlinable func value<T>(of components: Components, as format: T) throws -> T.Value where T: Format {
        try format.locale(Self.en_US.locale).parse(String(describing: components))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot -> Components
    //=------------------------------------------------------------------------=
    
    /// To use this method, all formatting characters must be marked as virtual.
    @inlinable func components<T>(in snapshot: Snapshot, as value: T.Type) throws -> Components where T: Value {
        let characters = snapshot.lazy.filter(\.nonvirtual).map(\.character)
        return try .init(characters: characters, integer: T.isInteger, unsigned: T.isUnsigned,
        signs: signs.components, digits: digits.components, separators: separators.components)
    }
}
