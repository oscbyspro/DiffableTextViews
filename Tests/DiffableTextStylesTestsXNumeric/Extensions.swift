//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextStylesXNumeric

//*============================================================================*
// MARK: * Lexicon
//*============================================================================*

extension Lexicon {
    
    //=------------------------------------------------------------------------=
    // MARK: Predicates
    //=------------------------------------------------------------------------=
    
    func nonvirtual(_ character: Character) -> Bool {
        signs.contains(character) || digits.contains(character) || separators[character] == .fraction
    }
}

#endif
