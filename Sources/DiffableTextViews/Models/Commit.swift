//
//  Commit.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-17.
//

//*============================================================================*
// MARK: * Commit
//*============================================================================*

/// A value and a snapshot describing it.
public struct Commit<Value> {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    public var value: Value
    public var snapshot: Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init(value: Value, snapshot: Snapshot) {
        self.value = value
        self.snapshot = snapshot
    }
}
