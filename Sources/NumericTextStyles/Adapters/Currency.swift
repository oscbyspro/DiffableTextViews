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
    
    public let format:  Format
    public let lexicon: Lexicon
    public let label:   Label

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ format: Format) {
        self.format  = format
        self.lexicon = .currency(code: format.currencyCode, locale: format.locale)
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
