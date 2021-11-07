//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale

// MARK: - NumericTextStyle

#warning("Rename Interfaces, later.")
public protocol NumericTextStyle {
    associatedtype Value
    associatedtype Bounds: NumericTextBounds where Bounds.Value == Value
    associatedtype Precision: NumericTextPrecision where Precision.Value == Value
    
    @inlinable func locale(_ newValue: Locale) -> Self
    @inlinable func prefix(_ newValue: String?) -> Self
    @inlinable func suffix(_ newValue: String?) -> Self
    
    @inlinable func bounds(_ newValue: Bounds) -> Self
    @inlinable func precision(_ newValue: Precision) -> Self
}

#warning("TODO")
public protocol NumericTextBounds {
    associatedtype Value
}

#warning("TODO")
public protocol NumericTextPrecision {
    associatedtype Value
}
