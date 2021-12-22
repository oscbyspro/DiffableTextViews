//
//  DigitsParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - DigitsParser

#warning("WIP")
public struct DigitsParser: Parser {
    public typealias Output = DigitsText

    // MARK: Properties
    
    @usableFromInline let digits: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init(digits: Set<Character>) {
        self.digits = digits
    }
    
    // MARK: Parse
    
    @inlinable public func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        while index < characters.endIndex {
            let character = characters[index]
            
            guard digits.contains(character) else { break }
            
            storage.append(character)
            characters.formIndex(after: &index)
        }
    }
    
    // MARK: Instances: Static
    
    public static let standard = Self(digits: Output.decimals)
}

