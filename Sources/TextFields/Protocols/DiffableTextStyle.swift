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
    
    func merge(_ snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot?
    
    func parse(_ snapshot: Snapshot) -> Value? // (!)
    
    // MARK: 2

    #warning("Should be applied to all calls that returns Snapshot.")
    func process(_ snapshot: Snapshot) -> Snapshot

    #warning("Should be applied to all calls that returns Value.")
    func process(_ value: Value) -> Value
}
    
// MARK: - Implementations

extension DiffableTextStyle {
    
    // MARK: 0
        
    @inlinable public func showcase(_ value: Value) -> Snapshot {
        snapshot(value)
    }
        
    // MARK: 1
    
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        snapshot.replace(range, with: content)
    }
    
    // MARK: 2

    @inlinable public func process(_ snapshot: Snapshot) -> Snapshot {
        snapshot
    }
    
    @inlinable public func process(_ value: Value) -> Value {
        value
    }
}
