//
//  Number.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import struct Foundation.Locale
import protocol Utilities.Transformable

// MARK: - Number

#warning("WIP")
@usableFromInline struct _Number: _Text, Transformable {
    @usableFromInline typealias Parser = _NumberParser
    
    // MARK: Properties
    
    @usableFromInline var sign: _Sign
    @usableFromInline var integer: _Digits
    @usableFromInline var separator: _Separator
    @usableFromInline var fraction: _Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = .init()
        self.integer = .init()
        self.separator = .init()
        self.fraction = .init()
    }
    
    // MARK: Getters
    
    @inlinable var isEmpty: Bool {
        sign.isEmpty && integer.isEmpty && separator.isEmpty && fraction.isEmpty
    }
    
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
    
    // MARK: Utilities
    
    #warning("Unused.")
    @inlinable func validate<Value: _Boundable & _Precise>(type: Value.Type) -> Bool {
        if type.isUnsigned {
            if !sign.isEmpty { return false }
        }
        
        if type.isInteger {
            if !separator.isEmpty { return false }
            if  !fraction.isEmpty { return false }
        }
        
        return true
    }
    
    // MARK: Parsers: Static

    @inlinable @inline(__always) static var parser: Parser {
        .decimal
    }
}

// MARK: - NumberParser

#warning("WIP")
#error("Rather than validate: UnsignedIntegerParser, IntegerParser, FloatParser where each has Output: _Number.")
@usableFromInline struct _NumberParser: _Parser {
    @usableFromInline typealias Output = _Number
    
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
    
    // MARK: Transformations
    
    @inlinable func locale(_ locale: Locale) -> Self {
        .init(sign: sign.locale(locale), digits: digits.locale(locale), separator: separator.locale(locale))
    }

    // MARK: Parse
    
    @inlinable func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        sign.parse(characters: characters, index: &index, storage: &storage.sign)
        
        // --------------------------------- //
        
        digits.parse(characters: characters, index: &index, storage: &storage.integer)
        guard !storage.integer.isEmpty else { return }
        
        // --------------------------------- //
        
        separator.parse(characters: characters, index: &index, storage: &storage.separator)
        guard !storage.separator.isEmpty else { return }

        // --------------------------------- //
        
        digits.parse(characters: characters, index: &index, storage: &storage.fraction)
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let decimal = Self(sign: .negatives, digits: .decimals, separator: .dot)
}

