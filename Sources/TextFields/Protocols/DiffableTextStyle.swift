//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

public protocol DiffableTextStyle {
    associatedtype Value: Equatable
    
    // 0 -> "0"
    func format(_ value: Value) -> Layout
    
    // "" -> 0
    func parse(_ layout: Layout) -> Value?

    // "-." -> "-0."
    func accept(_ proposal: Layout) -> Layout?
}
    
public extension DiffableTextStyle {
    // MARK: Default Implementations
    
    @inlinable func accept(_ proposal: Layout) -> Layout? {
        proposal
    }
}
