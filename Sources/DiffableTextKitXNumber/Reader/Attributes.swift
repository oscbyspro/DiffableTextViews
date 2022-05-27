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
    
    @usableFromInline private(set) var map = [Character: Attribute](minimumCapacity: 13)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ local: Components) {
        //=--------------------------------------=
        // (10) Digits
        //=--------------------------------------=
        for digit in Digit.allCases {
            self.map[local.digits[digit]] = .content
        }
        //=--------------------------------------=
        // (1) Separators
        //=--------------------------------------=
        self.map[local.separators[.fraction]] = .removable
        //=--------------------------------------=
        // (2) Signs
        //=--------------------------------------=
        for sign in Sign.allCases {
            self.map[local.signs[sign]] = .phantom.subtracting(.virtual)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Symbol {
        Symbol(character, as: map[character] ?? .phantom)
    }
}
