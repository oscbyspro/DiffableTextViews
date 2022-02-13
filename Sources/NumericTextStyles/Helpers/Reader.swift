//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Reader
//*============================================================================*

/// - Snapshot/count is O(1) and may be used without performance impact.
@usableFromInline struct Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let region: Region
    @usableFromInline var changes: Changes
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ changes: Changes, in region: Region) {
        self.region = region
        self.changes = changes
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: Region { .en_US }
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
        self.changes.replacement = Snapshot(changes.replacement.map(translateInput))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Symbol
    //=------------------------------------------------------------------------=

    @inlinable func translateInput(symbol: Symbol) -> Symbol {
        var character = symbol.character
        //=--------------------------------------=
        // MARK: Match
        //=--------------------------------------=
        if let component = ascii.signs[character] {
            character = region.signs[component]
        } else if let component = ascii.digits[character] {
            character = region.digits[component]
        } else if ascii.separators[character] != nil || region.separators[character] != nil {
            character = region.separators[.fraction]
        }
        //=--------------------------------------=
        // MARK: Symbol
        //=--------------------------------------=
        return Symbol(character, as: symbol.attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Commands
//=----------------------------------------------------------------------------=

extension Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: Single Sign Input
    //=------------------------------------------------------------------------=
    
    /// Interprets a single sign character as a: set sign command.
    @inlinable mutating func consumeSingleSignInput() -> Sign? {
        guard changes.replacement.count == 1 else { return nil } // snapshot.count is O(1)
        guard let sign = region.signs[changes.replacement.first!.character] else { return nil }
        self.changes.replacement.removeAll(); return sign
    }
}
