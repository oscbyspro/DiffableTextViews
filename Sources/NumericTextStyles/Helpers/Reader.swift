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
    
    @usableFromInline let region: Lexicon
    @usableFromInline var changes: Changes
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ changes: Changes, in region: Lexicon) {
        self.region = region
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
    // MARK: Symbol
    //=------------------------------------------------------------------------=

    @inlinable func translate(input: Symbol) -> Symbol {
        var character = input.character
        //=--------------------------------------=
        // MARK: Match
        //=--------------------------------------=
        if let component = ascii.signs[character] {
            character = region.signs[component]
        } else if let component = ascii.digits[character] {
            character = region.digits[component]
        } else if ascii.separators.contains(character) || region.separators.contains(character) {
            character = region.separators[.fraction]
        }
        //=--------------------------------------=
        // MARK: Symbol
        //=--------------------------------------=
        return Symbol(character, as: input.attribute)
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
        guard let sign = region.signs[changes.replacement.first!.character] else { return nil }
        self.changes.replacement.removeAll(); return sign
    }
}
