//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import NumericTextStyles

//*============================================================================*
// MARK: * Lexicon
//*============================================================================*

extension Lexicon {
    
    //=------------------------------------------------------------------------=
    // MARK: Predicates
    //=------------------------------------------------------------------------=
    
    func nonvirtual(_ character: Character) -> Bool {
        guard      signs[character] == nil       else { return true }
        guard     digits[character] == nil       else { return true }
        guard separators[character] != .fraction else { return true }
        return false
    }
}

#endif
