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
    
    /// A translation map for singular input characters.
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
    /// - Each separator in source and target translates to the target's fraction separator.
    ///
    @inlinable func keystroke(_ character: inout Character) {
        character = singular[character] ?? character
        character = fraction[character] ?? character
    }
}
