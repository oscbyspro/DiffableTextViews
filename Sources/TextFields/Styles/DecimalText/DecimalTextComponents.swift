//
//  DecimalTextComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-17.
//

import struct Foundation.Decimal

// MARK: - DecimalTextComponents

/// - Example: -123456.789
public struct DecimalTextComponents {
    @usableFromInline static let zero: String = "0"
    @usableFromInline static let sign: String = "-"
    @usableFromInline static let decimalSeparator: String = "."
    @usableFromInline static let digits = Set<Character>("0123456789")
    
    // MARK: Properties
    
    public var sign: String
    public var integerDigits: String
    public var decimalSeparator: String
    public var decimalDigits: String
    
    // MARK: Initializers
    
    @inlinable public init() {
        self.sign = ""
        self.integerDigits = ""
        self.decimalSeparator = ""
        self.decimalDigits = ""
    }
    
    // MARK: Descriptions
    
    @inlinable var isEmpty: Bool {
        sign.isEmpty && integerDigits.isEmpty && decimalSeparator.isEmpty && decimalDigits.isEmpty
    }
    
    // MARK: Utilities
    
    @inlinable func decimal() -> Decimal? {
        let characters = characters()
        
        guard !characters.isEmpty else {
            return .zero
        }
        
        return Decimal(string: characters)
    }
    
    @inlinable func characters() -> String {
        sign + integerDigits + decimalSeparator + decimalDigits
    }
}

extension DecimalTextComponents {

    // MARK: Initializers
    
    public init?(from characters: String) {
        var components = Self()
        var index = characters.startIndex
    
        Self.parse(
            prefix: Self.sign,
            in: characters,
            from: &index,
            into: &components.sign)
                
        Self.parse(
            charactersIn: Self.digits,
            in: characters,
            from: &index,
            into: &components.integerDigits)
                
        Self.parse(
            prefix: Self.decimalSeparator,
            in: characters,
            from: &index,
            into: &components.decimalSeparator)
                
        Self.parse(
            charactersIn: Self.digits,
            in: characters,
            from: &index,
            into: &components.decimalDigits)
        
        // validate
        guard characters[index...].isEmpty else {
            return nil
        }
        
        // complete
        self = components
    }
    
    // MARK: Helpers
    
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


