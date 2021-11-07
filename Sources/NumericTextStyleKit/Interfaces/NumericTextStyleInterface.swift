//
//  NumericTextStyleInterface.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale

// MARK: - NumericTextStyleInterface

public protocol NumericTextStyleInterface {
    associatedtype Value: NumericTextValue
    
    @inlinable func locale(_ locale: Locale) -> Self
    @inlinable func prefix(_ newValue: String?) -> Self
    @inlinable func suffix(_ newValue: String?) -> Self
    
    @inlinable func bounds(_ newValue: NumericTextBounds<Value>) -> Self
    @inlinable func precision(_ newValue: NumericTextPrecision<Value>) -> Self
}
