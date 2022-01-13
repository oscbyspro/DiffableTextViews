//
//  Cache.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-06.
//

//*============================================================================*
// MARK: * Cache
//*============================================================================*

@usableFromInline final class Cache<Value: Equatable> {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Value!
    @usableFromInline var state: State
    @usableFromInline var  mode:  Mode
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.state = State()
        self.mode = .showcase
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var snapshot: Snapshot {
        state.snapshot
    }
    
    @inlinable var selection: Range<Snapshot.Index> {
        state.selection
    }
}
