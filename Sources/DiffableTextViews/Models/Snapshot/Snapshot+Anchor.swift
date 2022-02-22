//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Anchor
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Sets the anchor to the endIndex.
    @inlinable mutating func anchor() {
        self._anchorIndex = endIndex
    }
    
    /// Sets the anchor to the position.
    @inlinable mutating func anchor(_ position: Index?) {
        self._anchorIndex = position
    }
}
