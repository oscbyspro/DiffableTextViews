//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public protocol DiffableTextStyle {
    associatedtype Value: Equatable = String
    
    func format(_ value: Value) -> String
        
    func snapshot(_ content: String) -> Snapshot
    
    func parse(_ content: String) -> Value?
}
