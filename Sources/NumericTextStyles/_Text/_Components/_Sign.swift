//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Sign

#warning("WIP")
@usableFromInline enum _Sign: String, Component {
    
    // MARK: Cases
    
    case positive = "+"
    case negative = "-"
    case none = ""
    
    // MARK: Initializers
    
    @inlinable init() {
        self = .none
    }
    
    // MARK: Getters
    
    @inlinable @inline(__always) var characters: String {
        rawValue
    }
}
