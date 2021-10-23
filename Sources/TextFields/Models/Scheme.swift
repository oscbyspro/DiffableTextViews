//
//  Scheme.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Scheme

@usableFromInline protocol Scheme {
    @inlinable static func size(of character: Character) -> Int
}

extension Character: Scheme {
    @inlinable static func size(of character: Character) -> Int { 1 }
}

extension UTF8: Scheme {
    @inlinable static func size(of character: Character) -> Int { character.utf8.count }
}

extension UTF16: Scheme {
    @inlinable static func size(of character: Character) -> Int { character.utf16.count }
}
