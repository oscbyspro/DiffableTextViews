//
//  UnsignedIntegerParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

import struct Foundation.Locale

// MARK: - UnsignedIntegerParser

public struct UnsignedIntegerParser: NumberParser {
    public typealias Output = NumberText
    
    // MARK: Properties
    
    public let digits: DigitsParser
    
    // MARK: Initializers
    
    @inlinable init(digits: DigitsParser) {
        self.digits = digits
    }
    
    // MARK: Transformations
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        .init(digits: digits.locale(locale))
    }

    // MARK: Parse
    
    @inlinable public func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        digits.parse(characters: characters, index: &index, storage: &storage.integer)
    }
    
    // MARK: Instances: Static
    
    public static let standard = Self(digits: .standard)
}
