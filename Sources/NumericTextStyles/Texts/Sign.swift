//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Sign

@usableFromInline enum Sign: Text {
    
    // MARK: Instances
    
    case none
    case positive
    case negative
    
    // MARK: Initializers
    
    @inlinable init() {
        self = .none
    }
        
    // MARK: Getters
    
    @inlinable var isEmpty: Bool {
        self == .none
    }
    
    @inlinable var characters: String {
        switch self {
        case .none:     return String()
        case .negative: return String(Self.minus)
        case .positive: return String(Self.plus)
        }
    }
    
    // MARK: Characters
    
    @usableFromInline static let plus:  Character = "+"
    @usableFromInline static let minus: Character = "-"    
    @usableFromInline static let all = Set<Character>([plus, minus])
}
