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
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension _NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Commit
    //=------------------------------------------------------------------------=
    
    @inlinable func commit(_ value: Value, _ number: Number, _ style: Format) -> Commit<Value> {
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(number.sign, for: value, in: &characters)
        //=--------------------------------------=
        // MARK: Characters -> Snapshot -> Commit
        //=--------------------------------------=
        return Commit(value, snapshot(characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
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
        translation.autocorrect(&snapshot); return snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
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
