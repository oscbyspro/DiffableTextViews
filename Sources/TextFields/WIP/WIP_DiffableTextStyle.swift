//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-14.
//

#warning("WIP")

// MARK: - DiffableTextStyle

public protocol WIP_DiffableTextStyle {
    typealias Snapshot = Layout // MARK: TODO
    
    func snapshot(characters: String) -> Snapshot
    
    func unsnapshot(snapshot: Snapshot) -> String
}

public extension WIP_DiffableTextStyle {
    
    // MARK: Implementation
    
    @inlinable func unsnapshot(snapshot: Snapshot) -> String {
        snapshot.reduce(map: \.character, where: \.content)
    }
}

#warning("...")

/*
 
 DiffableTextField($decimal, format: .decimal as Style & Adapter)
 
 */

public protocol WIP_DiffableTextAdapter {
    associatedtype Value
    
    func characters(value: Value) -> String
    
    func value(characters: String) -> Value?
}
