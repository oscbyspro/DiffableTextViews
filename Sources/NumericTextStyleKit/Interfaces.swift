//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale

// MARK: - NumericTextStyle

#warning("TODO")
public protocol NumericTextValue: Comparable {
    associatedtype NumericTextStyle: NumericTextStyleKit.NumericTextStyle

    @inlinable static func numericTextStyle(_ locale: Locale) -> NumericTextStyle
}

#warning("TODO")
public protocol NumericTextStyle {
    associatedtype Value: NumericTextValue
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
    associatedtype Value: Comparable
        
    @inlinable static var all: Self { get }
        
    @inlinable static func min(_ value: Value) -> Self
    @inlinable static func max(_ value: Value) -> Self
        
    @inlinable static func values(in values: ClosedRange<Value>) -> Self
}

#warning("TODO")
public protocol NumericTextPrecision {
    associatedtype Value: Comparable
        
    @inlinable static var  max: Self { get }
    @inlinable static func max(_ total: Int) -> Self
    @inlinable static func digits<R: RangeExpression>(_ total: R) -> Self where R.Bound == Int
}

#warning("TODO")
public protocol NumericTextPrecisionOfFloat: NumericTextPrecision {
    @inlinable static func max(integer: Int, decimal: Int) -> Self
    @inlinable static func max(integer: Int) -> Self
    @inlinable static func max(decimal: Int) -> Self
    
    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, decimal: R1) -> Self where R0.Bound == Int, R1.Bound == Int
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int
    @inlinable static func digits<R: RangeExpression>(decimal: R) -> Self where R.Bound == Int
}
