//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale
import protocol DiffableTextViews.DiffableTextStyle

// MARK: - NumericTextStyle

#warning("TODO")
public protocol NumericTextValue: BoundsSubject, PrecisionSubject {
    associatedtype NumericTextStyle: NumericTextStyleKit.NumericTextStyle

    @inlinable static func numericTextStyle(_ locale: Locale) -> NumericTextStyle
}

#warning("TODO")
public protocol NumericTextStyle: DiffableTextStyle where Value: BoundsSubject & PrecisionSubject {
    typealias Bounds = NumericTextStyleKit.Bounds<Value>
    typealias Precision = NumericTextStyleKit.Precision<Value>
    
    @inlinable func locale(_ newValue: Locale) -> Self
    @inlinable func prefix(_ newValue: String?) -> Self
    @inlinable func suffix(_ newValue: String?) -> Self
    
    #warning("Replace with initializer")
//    @inlinable func bounds(_ newValue: Bounds) -> Self
//    @inlinable func precision(_ newValue: Precision) -> Self
}
