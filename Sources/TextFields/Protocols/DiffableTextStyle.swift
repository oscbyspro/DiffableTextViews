//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

public protocol DiffableTextStyle {
    associatedtype Value: Equatable
    
    // 0 -> "0"
    func snapshot(_ value: Value) -> Snapshot
        
    // "" -> 0
    func parse(_ snapshot: Snapshot) -> Value?
    
    // "-." -> "-0."
    func autocorrect(_ snapshot: Snapshot) -> Snapshot
}
    
public extension DiffableTextStyle {
    // MARK: Default Implementation
    
    @inlinable func autocorrect(_ snapshot: Snapshot) -> Snapshot { snapshot }
}
