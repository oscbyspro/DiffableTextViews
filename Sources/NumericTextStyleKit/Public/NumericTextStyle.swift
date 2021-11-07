//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale
import protocol DiffableTextViews.DiffableTextStyle

// MARK: - NumericTextStyle

public protocol NumericTextStyle: DiffableTextStyle where Value: BoundsSubject & PrecisionSubject {
    typealias Bounds = NumericTextStyleKit.Bounds<Value>
    typealias Precision = NumericTextStyleKit.Precision<Value>
    
    @inlinable func locale(_ newValue: Locale) -> Self
    @inlinable func prefix(_ newValue: String?) -> Self
    @inlinable func suffix(_ newValue: String?) -> Self
    
    @inlinable func bounds(_ newValue: Bounds) -> Self
    @inlinable func precision(_ newValue: Precision) -> Self
}
