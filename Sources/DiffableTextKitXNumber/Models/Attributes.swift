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
// MARK: * Attributes [...]
//*============================================================================*

@usableFromInline struct Attributes {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var map = [Character: Attribute]()
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ components: Components) {
        //=--------------------------------------=
        // Signs
        //=--------------------------------------=
        for sign in components.signs.tokens.keys {
            self.map[sign] = .phantom.subtracting(.virtual)
        }
        //=--------------------------------------=
        // Digits
        //=--------------------------------------=
        for digit in components.digits.tokens.keys {
            self.map[digit] = .content
        }
        //=--------------------------------------=
        // Separators
        //=--------------------------------------=
        self.map[components.separators[.fraction]] = .removable
    }
    
    @inlinable subscript(character: Character) -> Attribute {
        map[character] ?? .phantom
    }
}
