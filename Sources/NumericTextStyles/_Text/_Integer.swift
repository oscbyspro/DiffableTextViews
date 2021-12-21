//
//  Integer.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import struct Foundation.Locale

// MARK: - Integer

#warning("WIP")
@usableFromInline struct _Integer: _Text {
    @usableFromInline typealias Parser = _IntegerParser

    // MARK: Properties
    
    @usableFromInline let sign: _Sign
    @usableFromInline let digits: _Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = .init()
        self.digits = .init()
    }
    
    // MARK: Getters
    
    @inlinable var characters: String {
        sign.characters + digits.characters
    }
    
    // MARK: Parsers: Static
    
    @inlinable static var parser: Parser { .decimal }
}

// MARK: - IntegerParser

#warning("WIP")
@usableFromInline struct _IntegerParser: _Parser {
    @usableFromInline typealias Output = _Integer
    
    // MARK: Properties
    
    @usableFromInline let sign: _SignParser
    @usableFromInline let digits: _DigitParser
    
    // MARK: Initializers
    
    @inlinable init(sign: _SignParser, digits: _DigitParser) {
        self.sign = sign
        self.digits = digits
    }
    
    // MARK: Transformations
    
    @inlinable func locale(_ locale: Locale) -> Self {
        .init(sign: sign.locale(locale), digits: digits.locale(locale))
    }
    
    // MARK: Parse
    
    #warning("WIP")
    @inlinable func parse<C: Collection>(_ characters: C, from index: inout C.Index, into storage: inout Output) where C.Element == Character {
        fatalError()
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let decimal = Self(sign: .negatives, digits: .decimals)
}
