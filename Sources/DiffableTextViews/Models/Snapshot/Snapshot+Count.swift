//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Count
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Optimizations
    //=------------------------------------------------------------------------=
    
    /// - Complexity: O(1).
    @inlinable var count: Int {
        _attributes.count
    }
    
    /// - Complexity: O(1).
    @inlinable var underestimatedCount: Int {
        _attributes.underestimatedCount
    }
}
