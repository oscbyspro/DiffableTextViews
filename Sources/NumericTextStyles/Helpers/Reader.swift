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
// MARK: * Reader
//*============================================================================*

/// - Snapshot/count is O(1) and may be used without performance impact.
@usableFromInline struct Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lexicon: Lexicon
    @usableFromInline var changes: Changes
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ changes: Changes, in region: Lexicon) {
        self.lexicon = region
        self.changes = changes
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: Lexicon { .en_US }
}

//=----------------------------------------------------------------------------=
// MARK: + Translate
//=----------------------------------------------------------------------------=

extension Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: Inputs
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func translateSingleCharacterInput() {
        guard changes.replacement.count == 1 else { return }
        self.changes.replacement = Snapshot(changes.replacement.map(translate))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=

    @inlinable func translate(input: Symbol) -> Symbol {
        Symbol(translate(input: input.character), as: input.attribute)
    }
    
    /// Conditional branches are ordered from most to least frequent.
    @inlinable func translate(input character: Character) -> Character {
        //=--------------------------------------=
        // MARK: Digit
        //=--------------------------------------=
        if let digit = ascii.digits[character] {
            return lexicon.digits[digit]
        //=--------------------------------------=
        // MARK: Separator
        //=--------------------------------------=
        } else if ascii.separators.contains(character) || lexicon.separators.contains(character) {
            // all separators result in fraction
            return lexicon.separators[.fraction]
        //=--------------------------------------=
        // MARK: Sign
        //=--------------------------------------=
        } else if let sign = ascii.signs[character] {
            return lexicon.signs[sign]
        //=--------------------------------------=
        // MARK: Miscellaneous
        //=--------------------------------------=
        } else { return character }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Commands
//=----------------------------------------------------------------------------=

extension Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: Single Sign Input
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func consumeSingleSignInput() -> Sign? {
        guard changes.replacement.count == 1 else { return nil }
        guard let sign = lexicon.signs[changes.replacement.first!.character] else { return nil }
        self.changes.replacement.removeAll(); return sign
    }
}
