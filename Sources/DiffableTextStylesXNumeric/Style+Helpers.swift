//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//=----------------------------------------------------------------------------=
// MARK: + Snapshot
//=----------------------------------------------------------------------------=

extension NumericTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    /// Assumes characters contain at least one content character.
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
                attribute = (separator == .fraction) ? .removable : .phantom
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

//=----------------------------------------------------------------------------=
// MARK: + Commit
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value, Number
    //=------------------------------------------------------------------------=
    
    @inlinable func commit(_ value: Value, _ number: Number, _ style: Format) -> Commit<Value> {
        var characters = style.sign(sign(number)).separator(separator(number)).format(value)
        fix(number.sign, for: value, in: &characters); return Commit(value, snapshot(characters))
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Fixes
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(_ number: Number) -> Format.Sign {
        number.sign == .negative ? .always : .automatic
    }
    
    @inlinable func separator(_ number: Number) -> Format.Separator {
        number.separator == .fraction ? .always : .automatic
    }
    
    /// This method exists because Apple's format styles always interpret zero as having a positive sign.
    @inlinable func fix(_ sign: Sign, for value: Value, in characters: inout String) {
        guard sign == .negative, value == .zero else { return }
        guard let index = characters.firstIndex(of: lexicon.signs[sign.toggled()]) else { return }
        characters.replaceSubrange(index...index, with: String(lexicon.signs[sign]))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Lexicon
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
