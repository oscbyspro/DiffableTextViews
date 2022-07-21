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
// MARK: * Translator
//*============================================================================*

@usableFromInline struct Translator {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var singular = [Character: Character]()
    @usableFromInline private(set) var fraction = [Character: Character]()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(from source: Components, to target: Components) {
        //=--------------------------------------=
        // Singular
        //=--------------------------------------=
        for (token,  character) in source.signs.characters {
            self.singular[character] = target.signs[token]
        }
        
        for (token,  character) in source.digits.characters {
            self.singular[character] = target.digits[token]
        }
        
        for (token,  character) in source.separators.characters {
            self.singular[character] = target.separators[token]
        }
        //=--------------------------------------=
        // Fraction
        //=--------------------------------------=
        let fraction = target.separators.characters[.fraction]

        for character in source.separators.characters.values {
            self.fraction[character] = fraction
        }
        
        for character in target.separators.characters.values {
            self.fraction[character] = fraction
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Translates a single keystroke.
    ///
    /// - Use it only to translate single character entries.
    /// - Separators in source and target translate to target's fraction separator.
    ///
    @inlinable func keystroke(_ character: inout Character) {
        character = singular[character, default: character]
        character = fraction[character, default: character]
    }
    
    @inlinable func keystroke(_ character: Character) -> Character {
        var character = character; keystroke(&character); return character
    }
}
