//
//  Adapter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public protocol Adapter {
    associatedtype Value = String
    
    func parse(content: String) throws -> Value
    
    func transcribe(value: Value) -> String
    
    func validate(content: String) -> Bool
    
    func snapshot(content: String) -> Snapshot
}
