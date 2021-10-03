//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

public protocol DiffableTextStyle {
    associatedtype Value: Equatable
    
    // 0 -> "0"
    func format(_ value: Value) -> Snapshot
    
    // "" -> 0
    func parse(_ snapshot: Snapshot) -> Value?

    // "-." -> "-0."
    func accept(_ proposal: Snapshot) -> Snapshot?
}
    
public extension DiffableTextStyle {
    // MARK: Default Implementations
    
    @inlinable func accept(_ proposal: Snapshot) -> Snapshot? {
        proposal
    }
}
