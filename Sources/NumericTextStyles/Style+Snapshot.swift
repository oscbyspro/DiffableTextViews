//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: + Snapshot
//=----------------------------------------------------------------------------=

extension NumericTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Characters -> Snapshot
    //=------------------------------------------------------------------------=

    /// Assumes that characters contains at least one content character.
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = characters.reduce(into: Snapshot()) {
            snapshot,  character in
            snapshot.append(Symbol(character, as: attribute(character)))
        }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        scheme.autocorrect(&snapshot); return snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Character -> Attribute
    //=------------------------------------------------------------------------=
    
    /// Conditional branches are ordered from most to least frequent.
    @inlinable func attribute(_ character: Character) -> Attribute {
        //=--------------------------------------=
        // MARK: Digit
        //=--------------------------------------=
        if lexicon.digits.contains(character) {
            return .content
        //=--------------------------------------=
        // MARK: Separator
        //=--------------------------------------=
        } else if let separator = lexicon.separators[character] {
            return separator == .fraction ? .removable : .phantom
        //=--------------------------------------=
        // MARK: Sign
        //=--------------------------------------=
        } else if lexicon.signs.contains(character) {
            return .phantom.subtracting(.virtual)
        //=--------------------------------------=
        // MARK: Miscellaneous
        //=--------------------------------------=
        } else { return .phantom }
    }
}
