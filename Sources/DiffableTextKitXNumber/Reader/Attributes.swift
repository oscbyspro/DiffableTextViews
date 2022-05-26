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
    @usableFromInline typealias Map = [Character: Attribute]
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let map: Map
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ local: Components) {
        var map = Map(minimumCapacity: 13)
        //=--------------------------------------=
        // (10) Digits
        //=--------------------------------------=
        for component in Digit.allCases {
            map[local.digits[component]] = .content
        }
        //=--------------------------------------=
        // (1) Separators
        //=--------------------------------------=
        map[local.separators[.fraction]] = .removable
        //=--------------------------------------=
        // (2) Signs
        //=--------------------------------------=
        for component in Sign.allCases {
            map[local.signs[component]] = .phantom.subtracting(.virtual)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        self.map = map
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Symbol {
        Symbol(character, as: map[character] ?? .phantom)
    }
}
