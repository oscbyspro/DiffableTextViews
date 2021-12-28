//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import protocol Utilities.Transformable

// MARK: - Sign

/// A representation of a system sign.
@usableFromInline enum Sign: Text, Transformable {
    
    // MARK: Instances
    
    case positive
    case negative
    
    // MARK: Initializers
    
    @inlinable init() {
        self = .positive
    }
        
    // MARK: Accessors
    
    @inlinable var characters: String {
        switch self {
        case .positive: return String()
        case .negative: return String(Self.minus)
        }
    }
    
    // MARK: Utilities
    
    @inlinable mutating func toggle() {
        switch self {
        case .positive: self = .negative
        case .negative: self = .positive
        }
    }
    
    // MARK: Characters
    
    @usableFromInline static let plus:  Character = "+"
    @usableFromInline static let minus: Character = "-"
    @usableFromInline static let all:  [Character: Sign] = [plus:  .positive, minus: .negative]
}

// MARK: - Sign: Descriptions

extension Sign: CustomStringConvertible {
    
    // MARK: Implementation
    
    @usableFromInline var description: String {
        switch self {
        case .positive: return "positive"
        case .negative: return "negative"
        }
    }
}
