//
//  Cache.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-06.
//

#warning("Rename as State, maybe.")

//*============================================================================*
// MARK: * Cache
//*============================================================================*

/// A snapshot of the upstream and downstream state.
@usableFromInline final class Cache<Scheme: DiffableTextViews.Scheme, Value: Equatable> {
    @usableFromInline typealias State = DiffableTextViews.State<Scheme>
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Value!
    @usableFromInline var state: State = State()
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var snapshot: Snapshot {
        state.snapshot
    }
    
    @inlinable var positions: Range<Position> {
        state.positions
    }
}
