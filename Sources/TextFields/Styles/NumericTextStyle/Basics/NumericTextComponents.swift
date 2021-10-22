//
//  NumericTextComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

// MARK: - NumericTextComponents

public struct NumericTextComponents {
    
    // MARK: Properties

    public var sign: Sign?
    public var integers: Digits
    public var separator: Separator?
    public var decimals: Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = .none
        self.integers = .init()
        self.separator = .none
        self.decimals = .init()
    }
    
    // MARK: Descriptions
    
    @inlinable public var hasSign: Bool {
        sign != nil
    }
    
    @inlinable public var hasSeparator: Bool {
        separator != nil
    }
            
    @inlinable public var hasDigits: Bool {
        !integers.isEmpty || !decimals.isEmpty
    }

    // MARK: Utilities
        
    @inlinable public func characters() -> String {
        [sign?.characters, integers.characters, separator?.characters, decimals.characters].compactMap({ $0 }).joined()
    }
    
    // MARK: Transformations
    
    @inlinable mutating public func toggleSign(with proposal: Sign) {
        if sign != proposal { sign = proposal } else { sign = nil }
    }
        
    // MARK: Components: Sign
    
    @frozen public enum Sign: String {
        @usableFromInline static let set = Set<Character>(positive.characters + negative.characters)
        
        case positive = "+"
        case negative = "-"
        
        @inlinable var characters: String { rawValue }
    }
    
    // MARK: Components: Separator
    
    @frozen public struct Separator {
        @usableFromInline static let system = Separator(characters: ".")
        
        // MARK: Properties
        
        public let characters: String
        
        // MARK: Initializers
        
        @inlinable init(characters: String) {
            self.characters = characters
        }
    }
    
    // MARK: Components: Digits
    
    @frozen public struct Digits {
        @usableFromInline static let zero = "0"
        @usableFromInline static let set = Set<Character>(zero + "123456789")
        
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
