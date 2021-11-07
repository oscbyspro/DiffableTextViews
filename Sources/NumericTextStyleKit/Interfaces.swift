//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale

// MARK: - NumericTextStyle

#warning("TODO")
public protocol NumericTextValue {
    associatedtype NumericTextStyle: NumericTextStyleKit.NumericTextStyle where NumericTextStyle.Value == Self

    @inlinable static func defaultNumericTextStyle(_ locale: Locale) -> NumericTextStyle
}

#warning("TODO")
public protocol NumericTextStyle {
    associatedtype Value: BoundsSubject & PrecisionSubject

    typealias Bounds = NumericTextStyleKit.Bounds<Value>
    typealias Precision = NumericTextStyleKit.Precision<Value>
    
    @inlinable func locale(_ newValue: Locale) -> Self
    @inlinable func prefix(_ newValue: String?) -> Self
    @inlinable func suffix(_ newValue: String?) -> Self
    
    #warning("Replace with initializer")
    @inlinable func bounds(_ newValue: Bounds) -> Self
    @inlinable func precision(_ newValue: Precision) -> Self
}
