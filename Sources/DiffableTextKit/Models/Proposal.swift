//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Proposal
//*============================================================================*

/// A snapshot and a proposed change that has not yet been applied to it.
public struct Proposal {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let base: Snapshot
    public var replacement: Snapshot
    public var range: Range<Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Snapshot, with replacement: Snapshot, in range: Range<Index>) {
        self.base = base; self.replacement = replacement; self.range = range
    }
    
    @inlinable public init<T>(_ base: Snapshot, with replacement: Snapshot, in range: Range<Offset<T>>) {
        self.base = base; self.replacement = replacement; self.range = base.range(at: range)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var lazy: Lazy { Lazy(self) }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns a snapshot with the proposed change applied to it.
    @inlinable public func merged() -> Snapshot {
        var S0 = base; S0.replaceSubrange(range, with: replacement); return S0
    }
    
    //*========================================================================*
    // MARK: * Lazy
    //*========================================================================*
    
    public struct Lazy {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let proposal: Proposal
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ proposal: Proposal) { self.proposal = proposal }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Returns a lazy snapshot with the proposed change applied to it.
        @inlinable public func merged() -> LazySequence<FlattenSequence<[Slice<Snapshot>]>> {[
            proposal.base[..<proposal.range.lowerBound],
            proposal.replacement[...],
            proposal.base[proposal.range.upperBound...]].lazy.joined()
        }
    }
}
