//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Proposal [...]
//*============================================================================*

/// A snapshot and a proposed change that has not yet been applied to it.
public struct Proposal {
    
    //=------------------------------------------------------------------------=
    
    public let base: Snapshot
    public var replacement: Snapshot
    public var range: Range<Index>
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: Snapshot, with replacement: Snapshot, in range: Range<Index>) {
        self.base = base; self.replacement = replacement; self.range = range
    }
    
    /// Returns a new snapshot with the proposed change applied to it.
    @inlinable public func merged() -> Snapshot {
        var result = base; result.replaceSubrange(range, with: replacement); return result
    }
}
