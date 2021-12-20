//
//  Digits.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Digits

#warning("WIP")
@usableFromInline struct _Digits: Component {
    
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
}

#warning("WIP")
@usableFromInline struct _ParsableDigits {
    
    // MARK: Properties
    
    @usableFromInline let digits: Set<Character>
}
