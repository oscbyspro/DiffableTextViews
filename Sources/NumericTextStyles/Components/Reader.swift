//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

//*============================================================================*
// MARK: * Reader
//*============================================================================*

@usableFromInline struct Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let region:  Region
    @usableFromInline var changes: Changes
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
            
    @inlinable init(_ changes: Changes, in region: Region) {
        self.region  = region
        self.changes = changes
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Interprets a single sign character as a: set sign command.
    @inlinable mutating func consumeSetSignInput() -> ((inout Number) -> Void)? {
        guard changes.replacement.count == 1 else { return nil } // snapshot.count is O(1)
        guard let sign = region.signs[changes.replacement.first!.character] else { return nil }
        //=--------------------------------------=
        // MARK: Set Sign Command Found
        //=--------------------------------------=
        self.changes.replacement.removeAll()
        return { number in number.sign = sign }
    }
}
