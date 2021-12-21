//
//  Digits.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Digits

#warning("WIP")
@usableFromInline struct _Digits: _Text {
    @usableFromInline typealias Parser = _DigitParser
    
    // MARK: Properties
    
    @usableFromInline private(set) var characters: String
    @usableFromInline private(set) var count: Int
    
    // MARK: Initializers
    
    @inlinable init() {
        self.characters = ""
        self.count = 0
    }
    
    // MARK: Getters
    
    @inlinable var isEmpty: Bool {
        characters.isEmpty
    }
    
    // MARK: Transformations
    
    @inlinable mutating func append(_ character: Character) {
        characters.append(character)
        count += 1
    }
    
    // MARK: Parsers: Static

    @inlinable @inline(__always) static var parser: Parser {
        .decimals
    }
    
    // MARK: Characters: Static
    
    @usableFromInline static let zero: Character = "0"
    @usableFromInline static let decimals = Set<Character>("0123456789")
}

// MARK: - DigitParser

#warning("WIP")
@usableFromInline struct _DigitParser: _Parser {
    @usableFromInline typealias Output = _Digits

    // MARK: Properties
    
    @usableFromInline let digits: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init(digits: Set<Character>) {
        self.digits = digits
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        for character in characters[index...] {
            guard digits.contains(character) else { break }
            
            storage.append(character)
            characters.formIndex(after: &index)
        }
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let decimals = Self(digits: Output.decimals)
}
