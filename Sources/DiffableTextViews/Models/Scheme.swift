//
//  Scheme.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Scheme

public protocol Scheme {
    @inlinable static func size(of character: Character) -> Int
    @inlinable static func size(of characters:   String) -> Int
}

extension Character: Scheme {
    @inlinable public static func size(of character: Character) -> Int { 1 }
    @inlinable public static func size(of characters:   String) -> Int { characters.count }
}

extension UTF8: Scheme {
    @inlinable public static func size(of character: Character) -> Int {  character.utf8.count }
    @inlinable public static func size(of characters:   String) -> Int { characters.utf8.count }
}

extension UTF16: Scheme {
    @inlinable public static func size(of character: Character) -> Int {  character.utf16.count }
    @inlinable public static func size(of characters:   String) -> Int { characters.utf16.count }
}

extension UnicodeScalar: Scheme {
    @inlinable public static func size(of character: Character) -> Int {  character.unicodeScalars.count }
    @inlinable public static func size(of characters:   String) -> Int { characters.unicodeScalars.count }
}
