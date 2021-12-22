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
    @usableFromInline typealias Output = Number
    
    // MARK: Properties
    
    @usableFromInline var sign: SignParser
    @usableFromInline var digits: DigitsParser
    @usableFromInline var separator: SeparatorParser
    @usableFromInline var options: Options
    
    // MARK: Initializers
    
    @inlinable init(sign: SignParser, digits: DigitsParser, separator: SeparatorParser, options: Options) {
        self.sign = sign
        self.digits = digits
        self.separator = separator
        self.options = options
    }
    
    // MARK: Transformations
    
    @inlinable func locale(_ locale: Locale) -> Self {
        .init(sign: sign.locale(locale), digits: digits.locale(locale), separator: separator.locale(locale), options: options)
    }
    
    @inlinable func options(_ options: Options) -> Self {
        transforming({ $0.options = options })
    }

    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        if !options.contains(.unsigned) {
            sign.parse(characters, index: &index, storage: &storage.sign)
        }
        
        // --------------------------------- //
        
        digits.parse(characters, index: &index, storage: &storage.integer)
        guard !options.contains(.integer), !storage.integer.isEmpty else { return }
        
        // --------------------------------- //
        
        separator.parse(characters, index: &index, storage: &storage.separator)
        guard !storage.separator.isEmpty else { return }

        // --------------------------------- //
        
        digits.parse(characters, index: &index, storage: &storage.fraction)
    }
    
    // MARK: Instances
    
    @usableFromInline static let standard = Self(sign: .standard, digits: .standard, separator: .standard, options: [])
}
