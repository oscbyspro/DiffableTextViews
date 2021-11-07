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
    
    func process(_ value: inout Value)

    func process(_ snapshot: inout Snapshot)
}
    
// MARK: - Implementations

extension DiffableTextStyle {
    
    // MARK: 0
        
    @inlinable public func showcase(_ value: Value) -> Snapshot {
        snapshot(value)
    }
        
    // MARK: 1
    
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        var snapshot = snapshot
        snapshot.replaceSubrange(range, with: content)
        return snapshot        
    }
    
    // MARK: 2

    @inlinable public func process(_ value: inout Value) {
        // ¯\_(ツ)_/¯
    }
    
    @inlinable public func process(_ snapshot: inout Snapshot) {
        // ¯\_(ツ)_/¯
    }
}
