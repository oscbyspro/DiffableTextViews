//
//  Digits.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Digits

#warning("WIP")
@usableFromInline struct _Digits: _Text {
    
    // MARK: Properties
    
    @usableFromInline private(set) var characters: String
    @usableFromInline private(set) var count: Int
    
    // MARK: Initializers
    
    @inlinable init() {
        self.characters = ""
        self.count = 0
    }
    
    // MARK: Transformations
    
    @inlinable mutating func append(_ character: Character) {
        characters.append(character)
        count += 1
    }

    // MARK: Characters: Static
    
    @usableFromInline static let zero: Character = "0"
    @usableFromInline static let decimals = Set<Character>("0123456789")
}

// MARK: - DigitParser

#warning("WIP")
@usableFromInline struct _DigitParser: _Parser {
    
    // MARK: Properties
    
    @usableFromInline let digits: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init(digits: Set<Character>) {
        self.digits = digits
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, from index: inout C.Index, into storage: inout _Digits) where C.Element == Character {
        for character in characters[index...] {
            guard digits.contains(character) else { return }
            
            storage.append(character)
            characters.formIndex(after: &index)
        }
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let decimals = Self(digits: _Digits.decimals)
}
