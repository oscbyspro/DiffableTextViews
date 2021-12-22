//
//  DigitsText.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - DigitsText

#warning("WIP")
public struct DigitsText: Text {
    
    // MARK: Properties
    
    @usableFromInline private(set) var _characters: String
    @usableFromInline private(set) var _count: Int
    
    // MARK: Properties: Getters
    
    @inlinable @inline(__always) public var characters: String { _characters }
    @inlinable @inline(__always) public var count: Int { _count }

    // MARK: Initializers
    
    @inlinable public init() {
        self._characters = ""
        self._count = 0
    }
    
    // MARK: Getters
    
    @inlinable @inline(__always) public var isEmpty: Bool {
        _characters.isEmpty
    }
    
    // MARK: Transformations
    
    @inlinable mutating func append(_ character: Character) {
        _characters.append(character)
        _count += 1
    }
    
    // MARK: Characters: Static
    
    @usableFromInline static let zero: Character = "0"
    @usableFromInline static let decimals = Set<Character>("0123456789")
}
