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

/// - Snapshot/count is O(1).
@usableFromInline struct Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lexicon: Lexicon

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ lexicon: Lexicon) {
        self.lexicon = lexicon
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: Lexicon { .ascii }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
 
    @inlinable func number<T>(_ proposal: Proposal, as value: T.Type)
    throws -> Number where T: NumberTextValue {
        //=--------------------------------------=
        // Proposal
        //=--------------------------------------=
        var proposal = proposal
        translateSingleCharacterInput(&proposal)
        let sign = consumeSingleSignInput(&proposal)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        var number = try lexicon.number(in: proposal(), as: T.self)
        if let sign = sign { number.sign = sign }
        return number
    }
}

//=----------------------------------------------------------------------------=
// MARK: Helpers
//=----------------------------------------------------------------------------=

extension Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: Translations
    //=------------------------------------------------------------------------=
    
    @inlinable func translateSingleCharacterInput(_ proposal: inout Proposal) {
        guard proposal.replacement.count == 1 else { return }
        proposal.replacement = Snapshot(proposal.replacement.map(translate))
    }
        
    @inlinable func translate(_ input: Symbol) -> Symbol {
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
            // all separators translates to fraction
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
    
    //=------------------------------------------------------------------------=
    // MARK: Commands
    //=------------------------------------------------------------------------=
    
    @inlinable func consumeSingleSignInput(_ proposal: inout Proposal) -> Sign? {
        guard proposal.replacement.count == 1 else { return nil }
        guard let sign = lexicon.signs[proposal.replacement.first!.character] else { return nil }
        proposal.replacement.removeAll(); return sign
    }
}
