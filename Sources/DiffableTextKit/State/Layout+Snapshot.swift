//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Snapshot
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    /// Should be faster than iterating considering that UTF16 characters size count is O(1).
    @inlinable func index(_ destination: Snapshot.Index) -> Index {
        Index(destination, at: .end(of: snapshot.characters[..<destination.character]))
    }
    
    /// Should be faster than iterating considering that UTF16 characters size count is O(1).
    @inlinable func indices(_ destination: Snapshot.Index) -> Range<Index> {
        let position = index(destination); return position ..< position
    }
}
