//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Sign

@usableFromInline enum Sign: String, Text {
    
    // MARK: Instances
    
    case none = ""
    case positive = "+"
    case negative = "-"
    
    // MARK: Initializers
    
    @inlinable init() {
        self = .none
    }
        
    // MARK: Getters
    
    @inlinable var isEmpty: Bool {
        rawValue.isEmpty
    }
    
    @inlinable var characters: String {
        rawValue
    }
    
    // MARK: Characters: Static
    
    @usableFromInline static let all = Set<Character>(["+", "-"])
}
