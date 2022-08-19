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
        source.signs/*-*/.tokens.forEach { self.singular[$0] = target.signs/*-*/[$1] }
        source.digits/**/.tokens.forEach { self.singular[$0] = target.digits/**/[$1] }
        source.separators.tokens.forEach { self.singular[$0] = target.separators[$1] }
        
        let fraction = target.separators.characters[.fraction]
        source.separators.tokens.keys.forEach { self.fraction[$0] = fraction }
        target.separators.tokens.keys.forEach { self.fraction[$0] = fraction }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Translates a keystroke.
    ///
    /// - Use it only to translate single character entries.
    /// - Separators in source and target translate to target's fraction separator.
    ///
    @inlinable func keystroke(_ character: inout Character) {
        character = singular[character, default: character]
        character = fraction[character, default: character]
    }
    
    @inlinable func translate(_ proposal: inout Proposal) {
        //=--------------------------------------=
        // Keystroke (1)
        //=--------------------------------------=
        if  proposal.replacement.count == 1 {
            var keystroke = proposal.replacement.first!
            self.keystroke(&keystroke.character)/*---*/
            proposal.replacement = Snapshot([keystroke])
        //=--------------------------------------=
        // Paste (2...), Backspace (0)
        //=--------------------------------------=
        } else { return }
    }
}
