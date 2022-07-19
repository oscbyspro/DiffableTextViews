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
// MARK: * Attributes
//*============================================================================*

@usableFromInline struct Attributes {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var storage = [Character: Attribute]()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ components: Components) {
        //=--------------------------------------=
        // Signs
        //=--------------------------------------=
        for sign in components.signs.tokens.keys {
            self.storage[sign] = .phantom.subtracting(.virtual)
        }
        //=--------------------------------------=
        // Digits
        //=--------------------------------------=
        for digit in components.digits.tokens.keys {
            self.storage[digit] = .content
        }
        //=--------------------------------------=
        // Separators
        //=--------------------------------------=
        self.storage[components.separators[.fraction]] = .removable
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Attribute {
        storage[character] ?? .phantom
    }
}
