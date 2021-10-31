//
//  Layout.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Layout

@usableFromInline protocol Layout {
    @inlinable static func size(of character: Character) -> Int
    @inlinable static func size(of characters:   String) -> Int
}

extension Character: Layout {
    @inlinable static func size(of character: Character) -> Int { 1 }
    @inlinable static func size(of characters:   String) -> Int { characters.count }
}

extension UTF8: Layout {
    @inlinable static func size(of character: Character) -> Int {  character.utf8.count }
    @inlinable static func size(of characters:   String) -> Int { characters.utf8.count }
}

extension UTF16: Layout {
    @inlinable static func size(of character: Character) -> Int {  character.utf16.count }
    @inlinable static func size(of characters:   String) -> Int { characters.utf16.count }
}

extension UnicodeScalar: Layout {
    @inlinable static func size(of character: Character) -> Int {  character.unicodeScalars.count }
    @inlinable static func size(of characters:   String) -> Int { characters.unicodeScalars.count }
}
