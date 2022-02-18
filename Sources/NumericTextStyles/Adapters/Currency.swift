//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

//*============================================================================*
// MARK: * Currency
//*============================================================================*

public struct NumericTextCurrencyAdapter<Format: NumericTextCurrencyFormat>: Adapter {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let format: Format
    public let lexicon: Lexicon
    public let label: Label

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ format: Format) {
        self.format = format
        self.lexicon = .currency(code: format.currencyCode, in: format.locale)
        self.label = .currency(code: format.currencyCode, with: lexicon)
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
    
    @inlinable init(code: String, lexicon: Lexicon) {
        self.code = code; self.locale = lexicon.locale.identifier
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
