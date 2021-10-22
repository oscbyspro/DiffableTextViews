//
//  NumericTextSchemeInt.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle

// MARK: - NumericTextSchemeInt

public enum NumericTextSchemeInt: NumericTextIntegerScheme {
    public typealias Number = Int
    public typealias Style = IntegerFormatStyle<Number>
    
    // MARK: Values
    
    public static var zero: Number { .zero }
    public static var min:  Number { .min  }
    public static var max:  Number { .max  }
    
    // MARK: Precision
    
               public static let maxTotalDigits: Int = String(describing: max).count
    @inlinable public static var maxUpperDigits: Int { maxTotalDigits }    
    
    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeInt.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeInt
}

#endif
