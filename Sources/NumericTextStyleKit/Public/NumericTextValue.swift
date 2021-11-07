//
//  NumericTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale
import protocol DiffableTextViews.DiffableTextStyle

// MARK: - NumericTextValue

public protocol NumericTextValue: BoundsSubject, PrecisionSubject {
    associatedtype NumericTextStyle: NumericTextStyleKit.NumericTextStyle
    
    @inlinable static func numericTextStyle(locale: Locale) -> NumericTextStyle
}

