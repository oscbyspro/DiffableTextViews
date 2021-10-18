//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - DiffableTextStyle

public protocol DiffableTextStyle {
    associatedtype Value: Equatable
    
    // MARK: 0
    
    func showcase(_ value: Value) -> Snapshot

    func snapshot(_ value: Value) -> Snapshot // (!)
    
    // MARK: 1
    
    func merge(_ snapshot: Snapshot, with replacement: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot?
        
    func process(_ snapshot: Snapshot) -> Snapshot
    
    // MARK: 2

    func parse(_ snapshot: Snapshot) -> Value? // (!)

    #warning("Should be applied to all calls of parse.")
    func process(_ value: Value) -> Value
}
    
// MARK: - Implementations

extension DiffableTextStyle {
    
    // MARK: 0
        
    @inlinable public func showcase(_ value: Value) -> Snapshot {
        snapshot(value)
    }
        
    // MARK: 1
    
    @inlinable public func merge(_ snapshot: Snapshot, with replacement: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        snapshot.replace(range, with: replacement)
    }
    
    @inlinable public func process(_ snapshot: Snapshot) -> Snapshot {
        snapshot
    }
    
    // MARK: 2

    @inlinable func process(_ value: Value) -> Value {
        value
    }
}
