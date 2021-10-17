//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - DiffableTextStyle

public protocol DiffableTextStyle {
    associatedtype Value: Equatable
    
    func showcase(_ value: Value) -> Snapshot

    func snapshot(_ value: Value) -> Snapshot
    
    func parse(_ snapshot: Snapshot) -> Value?

    func process(_ snapshot: Snapshot) -> Snapshot?
}
    
extension DiffableTextStyle {
    
    // MARK: Implementations
        
    @inlinable public func showcase(_ value: Value) -> Snapshot {
        snapshot(value)
    }
    
    @inlinable public func process(_ snapshot: Snapshot) -> Snapshot? {
        snapshot
    }
}
