//
//  NumericTextFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import struct Foundation.Locale

// MARK: - NumericTextFormat

@usableFromInline struct NumericTextFormat<Value: NumericTextValue> {
    @usableFromInline typealias Bounds = NumericTextStyles.Bounds<Value>
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>

    // MARK: Properties

    @usableFromInline private(set) var locale: Locale
    @usableFromInline private(set) var bounds: Bounds
    @usableFromInline private(set) var precision: Precision
    @usableFromInline private(set) var parser: NumberParser

    // MARK: Initializers
    
    @inlinable init(locale: Locale) {
        self.locale = locale
        self.bounds = .max
        self.precision = .max
        self.parser = .standard
        
        parser.update(locale: locale)
        parser.update(options: Value.options)
    }
    
    // MARK: Transformations
    
    @inlinable mutating func update(locale newValue: Locale) {
        locale = newValue
        parser.update(locale: newValue)
    }
    
    @inlinable mutating func update(bounds newValue: Bounds) {
        bounds = newValue
    }
    
    @inlinable mutating func update(precision newValue: Precision) {
        precision = newValue
    }
    
    // MARK: Characters
    
    @inlinable var zero: Character {
        Digits.zero
    }
    
    @inlinable var digits: Set<Character> {
        parser.digits.translatables
    }
    
    @inlinable var signs: [Character: Sign] {
        parser.sign.translatables
    }
    
    @inlinable var fractionSeparator: String {
        locale.decimalSeparator ?? Separator.dot
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ""
    }
        
    // MARK: Styles
    
    @inlinable func showcaseStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.showcaseStyle(), separator: .automatic)
    }
        
    @inlinable func editableStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyleThatUses(numberDigitsCount: NumberDigitsCount, separator: Bool) -> Value.FormatStyle {
        let precision = precision.editableStyleThatUses(numberDigitsCount: numberDigitsCount)
        return Value.style(locale: locale, precision: precision, separator: separator ? .always : .automatic)
    }
}
