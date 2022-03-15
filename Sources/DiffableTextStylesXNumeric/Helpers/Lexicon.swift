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
// MARK: * Lexicon
//*============================================================================*

public final class Lexicon {

    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let ascii = Lexicon(
    signs: .ascii(), digits: .ascii(), separators: .ascii())
    @usableFromInline static let en_US = Locale(identifier: "en_US")

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs:      Links<Sign>
    @usableFromInline let digits:     Links<Digit>
    @usableFromInline let separators: Links<Separator>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(signs: Links<Sign>, digits: Links<Digit>, separators: Links<Separator>) {
        self.signs = signs; self.digits = digits; self.separators = separators
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Kinds
//=----------------------------------------------------------------------------=

extension Lexicon {

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Requires that formatter.numberStyle == .none.
    @inlinable static func standard(_ formatter: NumberFormatter) -> Lexicon {
        Lexicon(signs: .standard(formatter), digits: .standard(formatter), separators: .standard(formatter))
    }
    
    /// Requires that formatter.numberStyle == .none.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Lexicon {
        Lexicon(signs: .currency(formatter), digits: .currency(formatter), separators: .currency(formatter))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Parse
//=----------------------------------------------------------------------------=

extension Lexicon {

    //=------------------------------------------------------------------------=
    // MARK: Number -> Value
    //=------------------------------------------------------------------------=
    
    /// Relies on the fact that implemented styles can parse unformatted numbers.
    @inlinable func value<T>(of number: Number, as format: T) throws -> T.Value where T: Format {
        try format.locale(Self.en_US).parse(number.characters())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot -> Number
    //=------------------------------------------------------------------------=
    
    /// To use this method, all formatting characters must be marked as virtual.
    @inlinable func number<T>(in snapshot: Snapshot, as value: T.Type) throws -> Number where T: Value {
        let characters = snapshot.lazy.filter(\.nonvirtual).map(\.character)
        return try .init(characters: characters, integer: T.isInteger, unsigned: T.isUnsigned,
        signs: signs.components, digits: digits.components, separators: separators.components)
    }
}
