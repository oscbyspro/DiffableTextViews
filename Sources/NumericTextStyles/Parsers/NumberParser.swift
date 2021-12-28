//
//  NumberParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

import struct Foundation.Locale
import protocol Utilities.Transformable

// MARK: - NumberParser

@usableFromInline struct NumberParser: Parser, Transformable {
    
    // MARK: Properties
    
    @usableFromInline private(set) var sign: SignParser
    @usableFromInline private(set) var digits: DigitsParser
    @usableFromInline private(set) var separator: SeparatorParser
    @usableFromInline private(set) var options: NumericTextOptions
    
    // MARK: Initializers
    
    @inlinable init(sign: SignParser, digits: DigitsParser, separator: SeparatorParser, options: NumericTextOptions) {
        self.sign = sign
        self.digits = digits
        self.separator = separator
        self.options = options
    }
    
    // MARK: Transformations

    @inlinable mutating func update(locale: Locale) {
        self.sign.update(locale: locale)
        self.digits.update(locale: locale)
        self.separator.update(locale: locale)
    }
    
    @inlinable mutating func update(options: NumericTextOptions) {
        self.options = options
    }

    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, value: inout Number) where C.Element == Character {
        
        // --------------------------------- //
        // MARK: Sign
        // --------------------------------- //
        
        if !options.contains(.unsigned) {
            sign.parse(characters, index: &index, value: &value.sign)
        }
        
        // --------------------------------- //
        // MARK: Integer
        // --------------------------------- //

        digits.parse(characters, index: &index, value: &value.integer)
        
        value.integer.removeRedundantZerosPrefix()
        value.integer.replaceWithZeroIfItIsEmpty()
        
        guard !options.contains(.integer) else { return }
        
        // --------------------------------- //
        // MARK: Separator
        // --------------------------------- //
        
        separator.parse(characters, index: &index, value: &value.separator)

        guard !value.separator.isEmpty else { return }
        
        // --------------------------------- //
        // MARK: Fraction
        // --------------------------------- //
        
        digits.parse(characters, index: &index, value: &value.fraction)
    }
    
    // MARK: Instances
    
    @usableFromInline static let standard = Self(sign: .standard, digits: .standard, separator: .standard, options: [])
}
