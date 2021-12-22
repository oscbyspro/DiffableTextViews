//
//  Number.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import struct Foundation.Locale

// MARK: - Number

#warning("WIP")
#warning("Rename as Components, maybe.")
public struct _Number: _Text {
    
    // MARK: Properties
    
    @usableFromInline var sign: _Sign
    @usableFromInline var integer: _Digits
    @usableFromInline var separator: _Separator
    @usableFromInline var fraction: _Digits
    
    // MARK: Initializers
    
    @inlinable public init() {
        self.sign = .init()
        self.integer = .init()
        self.separator = .init()
        self.fraction = .init()
    }
    
    // MARK: Getters
 
    @inlinable public var isEmpty: Bool {
        sign.isEmpty && integer.isEmpty && separator.isEmpty && fraction.isEmpty
    }
    
    @inlinable public var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
    
    // MARK: Transformations
    
    @inlinable mutating func toggle(sign proposal: _Sign) {
        if sign == proposal { sign = .none } else { sign = proposal }
    }
    
    // MARK: Utilities
    
    @inlinable var numberOfDigits: _Count {
        .init(integer: integer.count, fraction: fraction.count)
    }
    
    @inlinable func numberOfSignificantDigits() -> _Count {
        let integerValue = integer.count - numberOfRedundantIntegerDigits()
        let fractionValue = fraction.count - numberOfRedundantFractionDigits()
        return .init(integer: integerValue, fraction: fractionValue)
    }
    
    // MARK: Utilities: Helpers
        
    @inlinable func numberOfRedundantIntegerDigits() -> Int {
        integer.characters.prefix(while: { $0 == _Digits.zero }).count
    }
    
    @inlinable func numberOfRedundantFractionDigits() -> Int {
        fraction.characters.reversed().prefix(while: { $0 == _Digits.zero }).count
    }
}

// MARK: - UnsignedIntegerParser

public struct _UnsignedIntegerParser: _Parser {
    public typealias Output = _Number
    
    // MARK: Properties
    
    @usableFromInline let digits: _DigitsParser
    
    // MARK: Initializers
    
    @inlinable init(digits: _DigitsParser) {
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

// MARK: - IntegerParser

public struct _IntegerParser: _Parser {
    public typealias Output = _Number
    
    // MARK: Properties
    
    @usableFromInline let sign: _SignParser
    @usableFromInline let digits: _DigitsParser
    
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

// MARK: - FloatingPointParser

#warning("WIP")
public struct _FloatingPointParser: _Parser {
    public typealias Output = _Number
    
    // MARK: Properties
    
    @usableFromInline let sign: _SignParser
    @usableFromInline let digits: _DigitsParser
    @usableFromInline let separator: _SeparatorParser
    
    // MARK: Initializers
    
    @inlinable init(sign: _SignParser, digits: _DigitsParser, separator: _SeparatorParser) {
        self.sign = sign
        self.digits = digits
        self.separator = separator
    }
    
    // MARK: Transformations
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        .init(sign: sign.locale(locale), digits: digits.locale(locale), separator: separator.locale(locale))
    }

    // MARK: Parse
    
    @inlinable public func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
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
    
    public static let standard = Self(sign: .standard, digits: .standard, separator: .standard)
}

