//
//  Output.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-17.
//

//*============================================================================*
// MARK: * Output
//*============================================================================*

/// A snapshot and an optional value.
///
/// Sometimes when a style merges snapshots, it also parses its value.
/// In that case, the value should be returned with the snapshot so that
/// the snapshot is not parsed twice.
///
public struct Output<Value> {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Value?
    @usableFromInline var snapshot: Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init(_ snapshot: Snapshot, value: Value? = nil) {
        self.value = value
        self.snapshot = snapshot
    }
}
