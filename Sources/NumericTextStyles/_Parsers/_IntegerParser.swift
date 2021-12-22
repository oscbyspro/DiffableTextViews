//
//  IntegerParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

import struct Foundation.Locale

// MARK: - IntegerParser

public struct _IntegerParser: _NumberParser {
    public typealias Output = _NumberText
    
    // MARK: Properties
    
    public let sign: _SignParser
    public let digits: _DigitsParser
    
    // MARK: Initializers
    
    @inlinable init(sign: _SignParser, digits: _DigitsParser) {
        self.sign = sign
        self.digits = digits
    }
    
    // MARK: Transformations
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        .init(sign: sign.locale(locale), digits: digits.locale(locale))
    }

    // MARK: Parse
    
    @inlinable public func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        sign.parse(characters: characters, index: &index, storage: &storage.sign)
        digits.parse(characters: characters, index: &index, storage: &storage.integer)
    }
    
    // MARK: Instances: Static
    
    public static let standard = Self(sign: .standard, digits: .standard)
}
