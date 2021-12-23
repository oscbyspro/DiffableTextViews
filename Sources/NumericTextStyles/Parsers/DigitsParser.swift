//
//  DigitsParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - DigitsParser

@usableFromInline struct DigitsParser: Parser {
    @usableFromInline typealias Output = Digits

    // MARK: Properties
    
    @usableFromInline let zero: Character
    @usableFromInline let digits: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init(zero: Character, digits: Set<Character>) {
        assert(digits.contains(zero))
        self.zero = zero
        self.digits = digits
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        while index < characters.endIndex {
            let character = characters[index]
            
            guard digits.contains(character) else { break }
            
            storage.append(character)
            characters.formIndex(after: &index)
        }
    }
    
    // MARK: Instances
    
    @usableFromInline static let standard = Self(zero: Output.zero, digits: Output.decimals)
}
