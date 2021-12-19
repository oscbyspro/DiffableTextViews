//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - DiffableTextStyle

public protocol DiffableTextStyle {
    associatedtype Value: Equatable
    
    // MARK: Snapshot
    
    func snapshot(showcase value: Value) -> Snapshot

    func snapshot(editable value: Value) -> Snapshot // required (!)
    
    // MARK: Interpret
    
    func parse(snapshot: Snapshot) -> Value? // required (!)

    func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot?
    
    // MARK: Process
    
    func process(value: inout Value)

    func process(snapshot: inout Snapshot)
}
    
// MARK: - Implementations

extension DiffableTextStyle {
    
    // MARK: Snapshot

    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(editable: value)
    }

    // MARK: Interpret

    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        var snapshot = snapshot
        snapshot.replaceSubrange(range, with: content)
        return snapshot
    }

    // MARK: Process

    @inlinable public func process(value: inout Value) {
        // ¯\_(ツ)_/¯
    }

    @inlinable public func process(snapshot: inout Snapshot) {
        // ¯\_(ツ)_/¯
    }
}
