//
//  NumberTextComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

// MARK: - NumberTextComponents

public struct NumberTextComponents {
    
    // MARK: Properties

    public var minus = String()
    public var upper = String()
    public var separator = String()
    public var lower = String()
    
    // MARK: Initializers
    
    public init?(from characters: String) {
        
        // --------------------------------- //
        
        var index = characters.startIndex
        
        // --------------------------------- //

        Self.parse(
            prefix: Self.minus,
            in: characters,
            from: &index,
            into: &minus)

        Self.parse(
            charactersIn: Self.digits,
            in: characters,
            from: &index,
            into: &upper)
        
        Self.parse(
            prefix: Self.separator,
            in: characters,
            from: &index,
            into: &separator)

        Self.parse(
            charactersIn: Self.digits,
            in: characters,
            from: &index,
            into: &lower)
        
        // --------------------------------- //
        
        guard characters[index...].isEmpty else { return nil }
        
        // --------------------------------- //
    }
    
    // MARK: Descriptions
    
    @inlinable var isEmpty: Bool {
        minus.isEmpty && upper.isEmpty && separator.isEmpty && lower.isEmpty
    }
    
    @inlinable var hasNoDigits: Bool {
        upper.isEmpty && lower.isEmpty
    }
    
    // MARK: Utilities
    
    @inlinable func characters() -> String {
        minus + upper + separator + lower
    }
    
    // MARK: Transformations
    
    @inlinable mutating func toggleSign() {
        minus = minus.isEmpty ? Self.minus : String()
    }
}

extension NumberTextComponents {
    
    // MARK: Properties: Static
    
    @usableFromInline static let minus: String = "-"
    @usableFromInline static let separator: String = "."
    @usableFromInline static let zero: String = "0"
    @usableFromInline static let digits = Set<Character>("0123456789")

}

extension NumberTextComponents {
    
    // MARK: Helpers: Static
    
    @inlinable static func parse(prefix: String, in characters: String, from index: inout String.Index, into storage: inout String) {
        if characters[index...].hasPrefix(prefix) {
            storage.append(prefix)
            index = characters.index(index, offsetBy: prefix.count)
        }
    }

    @inlinable static func parse(charactersIn set: Set<Character>, in characters: String, from index: inout String.Index, into storage: inout String) {
        for character in characters[index...] {
            guard set.contains(character) else { break }
            
            storage.append(character)
            index = characters.index(after: index)
        }
    }
}
