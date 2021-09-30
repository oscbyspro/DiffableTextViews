//
//  Adapter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public protocol Adapter {
    associatedtype Value = String
        
    func transcribe(value: Value) -> String
            
    #warning("Maybe rather than throw, return an enum with cases: .failure, .partial, .success(Value).")
    func parse(content: String) throws -> Value
    
    func snapshot(content: String) -> Snapshot
}

// MARK: - WIP

#warning("An idea.")
enum ParseOutput<Value> {
    case failure // would cancel input
    case partial // would accept input but not update value
    case success(Value) // would accept input and update value
}
