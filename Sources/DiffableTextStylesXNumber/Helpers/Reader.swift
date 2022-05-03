//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// - Snapshot/count is O(1) and may be used without performance impact.
@usableFromInline struct Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var changes: Changes
    @usableFromInline let lexicon: Lexicon

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ changes: Changes, _ lexicon: Lexicon) {
        self.changes = changes
        self.lexicon = lexicon
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: Lexicon { .ascii }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func translateSingleCharacterInput() {
        guard changes.replacement.count == 1 else { return }
        self .changes.replacement = Snapshot(changes.replacement.map(translate))
    }
    
    @inlinable mutating func consumeSingleSignInput() -> Sign? {
        guard changes.replacement.count == 1 else { return nil }
        guard let sign = lexicon.signs[changes.replacement.first!.character] else { return nil }
        self.changes.replacement.removeAll(); return sign
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func translate(input: Symbol) -> Symbol {
        let character: Character
        //=--------------------------------------=
        // Digit
        //=--------------------------------------=
        if let digit = ascii.digits[input.character] {
            character = lexicon.digits[digit]
        //=--------------------------------------=
        // Separator
        //=--------------------------------------=
        } else if ascii.separators.contains(input.character) ||
        lexicon.separators.contains(input.character) {
            // all separators translated as fraction
            character = lexicon.separators[.fraction]
        //=--------------------------------------=
        // Sign
        //=--------------------------------------=
        } else if let sign = ascii.signs[input.character] {
            character = lexicon.signs[sign]
        //=--------------------------------------=
        // Miscellaneous
        //=--------------------------------------=
        } else { character = input.character }
        //=--------------------------------------=
        // Done
        //=--------------------------------------=
        return Symbol(character, as: input.attribute)
    }
}
