//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

#warning("WIP")

public protocol WIP_DiffableTextStyle {
    associatedtype Value
    
    func snapshot(_ value: Value) -> Snapshot
    
    func parse(_ snapshot: Snapshot) -> Value?
    
    func SOMETHING_ELSE()
}
