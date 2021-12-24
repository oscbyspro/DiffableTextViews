//
//  NumberParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

import struct Foundation.Locale
import protocol Utilities.Transformable

// MARK: - NumberParser

public struct NumberParser: Parser, Transformable {
    
    // MARK: Properties
    
    @usableFromInline var sign: SignParser
    @usableFromInline var digits: DigitsParser
    @usableFromInline var separator: SeparatorParser
    @usableFromInline var options: NumberTypeOptions
    
    // MARK: Initializers
    
    @inlinable init(sign: SignParser, digits: DigitsParser, separator: SeparatorParser, options: NumberTypeOptions) {
        self.sign = sign
        self.digits = digits
        self.separator = separator
        self.options = options
    }
    
    // MARK: Transformations
    
    @inlinable func locale(_ locale: Locale) -> Self {
        .init(sign: sign.locale(locale), digits: digits.locale(locale), separator: separator.locale(locale), options: options)
    }
    
    @inlinable func options(_ options: NumberTypeOptions) -> Self {
        transforming({ $0.options = options })
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
