//
//  Format.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import Foundation
import Quick

//*============================================================================*
// MARK: * Format
//*============================================================================*

@usableFromInline struct Format<Value: Valuable> {
    @usableFromInline typealias Bounds = NumericTextStyles.Bounds<Value>
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var locale: Locale
    @usableFromInline private(set) var bounds: Bounds
    @usableFromInline private(set) var precision: Precision
    @usableFromInline private(set) var parser: NumberParser

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale) {
        self.locale = locale
        self.bounds = .standard
        self.precision = .standard
        self.parser = .standard

        parser.update(locale: locale)
        parser.update(options: Value.options)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(locale: Locale) {
        self.locale = locale
        self.parser.update(locale: locale)
    }
    
    @inlinable mutating func update(bounds: Bounds) {
        self.bounds = bounds
    }
    
    @inlinable mutating func update(precision: Precision) {
        self.precision = precision
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable var signs: [Character: Sign] {
        Sign.all
    }
 
    @inlinable var zero: Character {
        Digits.zero
    }
    
    @inlinable var digits: Set<Character> {
        Digits.decimals
    }
    
    @inlinable var fractionSeparator: String {
        locale.decimalSeparator ?? Separator.dot
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ""
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func showcaseStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.showcaseStyle(), separator: .automatic)
    }
        
    @inlinable func editableStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> Value.FormatStyle {
        let precision: Value.PrecisionStyle = precision.editableStyleThatUses(number: number)
        let separator: Value.SeparatorStyle = number.separator.isEmpty ? .automatic : .always
        return Value.style(locale: locale, precision: precision, separator: separator)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation - Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func correct(sign: inout Sign) {
        switch sign {
        case .positive:
            if bounds.max >  .zero { break }
            if bounds.min == .zero { break }
            sign.toggle()
        case .negative:
            if bounds.min <  .zero { break }
            sign.toggle()
        }
    }
    
    @inlinable func validate(sign: Sign) throws {
        guard sign == sign.transforming(correct) else {
            throw Redacted.mark(sign).text("is not permitted in").mark(bounds)
        }
    }
    
    //
    // MARK: Validation - Value
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(value: Value) throws {
        guard bounds.contains(value) else {
            throw Redacted.mark(value).text("is not in").mark(bounds)
        }
    }
}
