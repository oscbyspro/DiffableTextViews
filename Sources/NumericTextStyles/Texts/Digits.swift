//
//  Digits.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Digits

@usableFromInline struct Digits: Text {
    
    // MARK: Properties
    
    @usableFromInline private(set) var characters: String

    // MARK: Initializers
    
    @inlinable init() {
        self.characters = ""
    }
    
    // MARK: Getters
    
    @inlinable var count: Int {
        characters.count
    }
    
    @inlinable var isEmpty: Bool {
        characters.isEmpty
    }
    
    // MARK: Transformations
    
    @inlinable mutating func append(_ character: Character) {
        characters.append(character)
    }
    
    @inlinable mutating func removeRedundantZerosPrefix() {
        characters.removeSubrange(..<characters.dropLast().prefix(while: { $0 == Self.zero }).endIndex)
    }
    
    @inlinable mutating func replaceWithZeroIfItIsEmpty() {
        guard isEmpty else { return }; characters.append(Self.zero)
    }

    // MARK: Characters
    
    @usableFromInline static let zero: Character = "0"
    @usableFromInline static let decimals = Set<Character>("0123456789")
}
