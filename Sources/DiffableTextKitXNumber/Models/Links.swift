//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Links
//*============================================================================*

/// A mapping model between tokens and characters.
@usableFromInline struct Links<Token: DiffableTextKitXNumber.Token> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var tokens:     [Character: Token]
    @usableFromInline private(set) var characters: [Token: Character]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Links each component to a character.
    @inlinable init(character: (Token) -> Character) {
        let tokens = Token.allCases
        //=--------------------------------------=
        // Count
        //=--------------------------------------=
        self.tokens     = .init(minimumCapacity: tokens.count)
        self.characters = .init(minimumCapacity: tokens.count)
        //=--------------------------------------=
        // Links
        //=--------------------------------------=
        for token in tokens {
            self.tokens    [character(token)] = token
            self.characters[token] = character(token)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func ascii() -> Self {
        Self(character: { $0.character })
    }
    
    @inlinable static func standard(_ formatter: NumberFormatter) -> Self {
        Self(character: { $0.standard(formatter) })
    }
    
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        Self(character: { $0.currency(formatter) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(token: Token) -> Character {
        characters[token]!
    }
    
    @inlinable subscript(character: Character) -> Token? {
        tokens[character]
    }
}
