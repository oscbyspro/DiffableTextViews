//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// A snapshot and one continuous change that has not yet been applied to it.
public struct Proposal {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let snapshot: Snapshot
    public var replacement: Snapshot
    public var range: Range<Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ snapshot: Snapshot, with characters: String, in range: Range<Index>) {
        self.snapshot = snapshot
        self.replacement = Snapshot(characters, as: .content)
        self.range = range
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns a new snapshot with the proposed change applied to it.
    @inlinable public func merged() -> Snapshot {
        var result = snapshot
        result.replaceSubrange(range, with: replacement)
        return result
    }
}
