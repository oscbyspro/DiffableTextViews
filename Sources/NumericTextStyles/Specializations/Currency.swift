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

//*============================================================================*
// MARK: * Currency
//*============================================================================*

public struct Currency: NumericTextSpecialization {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let label:   Label
    public let lexicon: Lexicon
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    #warning("Make more obvious that it uses cache.")
    @inlinable init(code: String, locale: Locale) {
        self.lexicon = Lexicon.currency(code: code, locale: locale)
        self.label   = Label.currency(code: code, lexicon: lexicon)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable public func autocorrect(snapshot: inout Snapshot) {
        guard !label.characters.isEmpty else { return }
        guard let range = label.range(in: snapshot) else { return }
        snapshot.update(attributes: range) { attribute in attribute = .phantom }
    }
}
