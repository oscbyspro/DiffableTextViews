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
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
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
    // MARK: Snapshot
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

//=----------------------------------------------------------------------------=
// MARK: + Format
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Strategies
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(_ number: Number) -> Format.Sign {
        number.sign == .negative ? .always : .automatic
    }
    
    @inlinable func separator(_ number: Number) -> Format.Separator {
        number.separator == .fraction ? .always : .automatic
    }

    //=------------------------------------------------------------------------=
    // MARK: Fixes
    //=------------------------------------------------------------------------=
    
    /// This method exists because Apple's format styles always interpret zero as having a positive sign.
    @inlinable func fix(_ sign: Sign, for value: Value, in characters: inout String) {
        guard sign == .negative, value == .zero else { return }
        guard let position = characters.firstIndex(of: lexicon.signs[sign.toggled()]) else { return }
        characters.replaceSubrange(position...position, with: String(lexicon.signs[sign]))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
    
    @inlinable func value(_ number: Number) throws -> Value {
        try lexicon.value(of: number, as: format)
    }
    
    @inlinable func number(_ snapshot: Snapshot) throws -> Number {
        try lexicon.number(in: snapshot, as: Value.self)
    }
}
