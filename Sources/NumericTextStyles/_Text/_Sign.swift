//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Sign

#warning("WIP")
public enum _Sign: String, _Text {
    
    // MARK: Cases
    
    case none = ""
    case positive = "+"
    case negative = "-"
    
    // MARK: Initializers
    
    @inlinable public init() {
        self = .none
    }
        
    // MARK: Getters
    
    @inlinable @inline(__always) public var isEmpty: Bool {
        rawValue.isEmpty
    }
    
    @inlinable @inline(__always) public var characters: String {
        rawValue
    }
}
