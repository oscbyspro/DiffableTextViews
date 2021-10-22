//
//  NumericTextComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

// MARK: - NumericTextComponents

#warning("Consider: Optional<Sign> and Optional<Separator>...")
public struct NumericTextComponents {
    @usableFromInline typealias Configuration = NumericTextConfiguration
    
    // MARK: Properties

    public var sign: Sign
    public var integers: Digits
    public var separator: Separator
    public var decimals: Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = .none
        self.integers = .init()
        self.separator = .none
        self.decimals = .init()
    }
    
    // MARK: Utilities
    
    @inlinable public func characters() -> String {
        sign.rawValue + integers.characters + separator.rawValue + decimals.characters
    }
    
    // MARK: Transformations
    
    @inlinable mutating public func toggleSign(with proposal: Sign) {
        if sign != proposal { sign = proposal } else { sign = .none }
    }
    
    // MARK: Components: Sign
    
    @frozen public enum Sign: String {
        @usableFromInline static let all = Set<Character>(positive.rawValue + negative.rawValue)
        
        case positive = "+"
        case negative = "-"
        case none = ""
    }
    
    // MARK: Components: Separator
    
    @frozen public enum Separator: String {
        case some = "."
        case none = ""
    }
    
    // MARK: Components: Digits
    
    @frozen public struct Digits {
        @usableFromInline static let all = Set<Character>(zero + nonzero)
        @inlinable        static var zero:    String { "0" }
        @inlinable        static var nonzero: String { "123456789" }
        
        // MARK: Properties
        
        @usableFromInline var count: Int = 0
        @usableFromInline var characters: String = ""
        
        // MARK: Initializers
        
        @inlinable init() { }
        
        // MARK: Utilities
        
        @inlinable var isEmpty: Bool {
            characters.isEmpty
        }
        
        @inlinable mutating func append(_ character: Character) {
            count += 1
            characters.append(character)
        }
    }
}
