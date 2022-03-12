//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

#warning("A separate file is excessive for a single method.")
//=----------------------------------------------------------------------------=
// MARK: + Snapshot
//=----------------------------------------------------------------------------=

extension NumericTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Characters -> Snapshot
    //=------------------------------------------------------------------------=
    
    /// Assumes that characters contains at least one content character.
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = characters.reduce(into: Snapshot()) { snapshot, character in
            let attribute: Attribute
            //=----------------------------------=
            // MARK: Digit
            //=----------------------------------=
            if lexicon.digits.contains(character) {
                attribute = .content
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
            } else if let separator = lexicon.separators[character] {
                attribute = separator == .fraction ? .removable : .phantom
            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=
            } else if lexicon.signs.contains(character) {
                attribute = .phantom.subtracting(.virtual)
            //=----------------------------------=
            // MARK: Miscellaneous
            //=----------------------------------=
            } else { attribute = .phantom }
            //=----------------------------------=
            // MARK: Insert
            //=----------------------------------=
            snapshot.append(Symbol(character, as: attribute))
        }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        scheme.autocorrect(&snapshot); return snapshot
    }
}
