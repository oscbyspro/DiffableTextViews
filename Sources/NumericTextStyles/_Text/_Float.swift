//
//  Float.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import struct Foundation.Locale

// MARK: - Float

#warning("WIP")
@usableFromInline struct _Float: _Text {
    @usableFromInline typealias Parser = _FloatParser
    
    // MARK: Properties
    
    @usableFromInline let sign: _Sign
    @usableFromInline let integer: _Digits
    @usableFromInline let separator: _Separator
    @usableFromInline let fraction: _Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = .init()
        self.integer = .init()
        self.separator = .init()
        self.fraction = .init()
    }
    
    // MARK: Getters
    
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
    
    // MARK: Parsers: Static

    @inlinable static var parser: Parser { .decimal }
}

// MARK: - FloatParser

#warning("WIP")
@usableFromInline struct _FloatParser: _Parser {
    @usableFromInline typealias Output = _Float
    
    // MARK: Properties
    
    @usableFromInline let sign: _SignParser
    @usableFromInline let digits: _DigitParser
    @usableFromInline let separator: _SeparatorParser
    
    // MARK: Initializers
    
    @inlinable init(sign: _SignParser, digits: _DigitParser, separator: _SeparatorParser) {
        self.sign = sign
        self.digits = digits
        self.separator = separator
    }
    
    @inlinable init(integer: _IntegerParser, separator: _SeparatorParser) {
        self.init(sign: integer.sign, digits: integer.digits, separator: separator)
    }
    
    // MARK: Transformations
    
    @inlinable func locale(_ locale: Locale) -> Self {
        .init(sign: sign.locale(locale), digits: digits.locale(locale), separator: separator.locale(locale))
    }
    
    // MARK: Parse
    
    #warning("WIP")
    @inlinable func parse<C: Collection>(_ characters: C, from index: inout C.Index, into storage: inout Output) where C.Element == Character {
        fatalError()
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let decimal = Self(integer: .decimal, separator: .dot)
}
