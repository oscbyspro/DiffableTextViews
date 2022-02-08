//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Changes
//*============================================================================*

/// A snapshot, and one continuous change that has not yet been applied to it.
public struct Changes {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let snapshot: Snapshot
    public var replacement: Snapshot
    public var range: Range<Snapshot.Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<S: Scheme>(_ snapshot: Snapshot, change: (content: String, range: Range<Layout<S>.Index>)) {
        self.snapshot = snapshot
        self.replacement = Snapshot(change.content, as: .content)
        self.range = change.range.lowerBound.snapshot ..< change.range.upperBound.snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Merges its contents to form a new snapshot.
    @inlinable public func proposal() -> Snapshot {
        var result = snapshot; result.replaceSubrange(range, with: replacement); return result
    }
}
