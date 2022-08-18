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
        self.map[components.separators[Separator .fraction]] = .removable
        components.digits.tokens.keys.forEach { self.map[$0] = .content }
        components.signs .tokens.keys.forEach { self.map[$0] = .phantom.subtracting(.virtual) }
    }
    
    @inlinable subscript(character: Character) -> Attribute {
        map[character] ?? .phantom
    }
}
