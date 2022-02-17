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
// MARK: * Label
//*============================================================================*

@usableFromInline struct Label {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let characters: String
    @usableFromInline let location: Location
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ string: String, at location: Location) {
        self.characters = string
        self.location = location
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    @usableFromInline enum Location { case prefix, suffix }
}

//=----------------------------------------------------------------------------=
// MARK: + Unformat
//=----------------------------------------------------------------------------=

extension Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable func unformat(snapshot: inout Snapshot) {
        guard let range = range(in: snapshot) else { return }
        snapshot.update(attributes: range) {
            attribute in attribute.insert(.virtual)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// Naive search is OK because labels are close to the edge and unique from edge to end.
    @inlinable func range(in snapshot: Snapshot) -> Range<Snapshot.Index>? {
        Search.range(of: characters, in: snapshot, reversed: location == .suffix)
    }
}
