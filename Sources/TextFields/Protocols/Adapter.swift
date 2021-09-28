//
//  Adapter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public protocol Adapter {
    associatedtype Value = String
        
    func transcribe(value: Value) -> String
        
    func snapshot(content: String) -> Snapshot
    
    func parse(content: String) throws -> Value
}
