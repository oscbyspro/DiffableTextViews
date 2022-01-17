//
//  Output.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-17.
//

//*============================================================================*
// MARK: * Output
//*============================================================================*

public struct Output<Value> {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Value?
    @usableFromInline var snapshot: Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ snapshot: Snapshot) {
        self.value = nil
        self.snapshot = snapshot
    }
    
    @inlinable public init(_ snapshot: Snapshot, value: Value?) {
        self.value = value
        self.snapshot = snapshot
    }
}
