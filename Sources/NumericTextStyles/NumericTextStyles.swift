//
//  NumericTextStyles.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * Decimals
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal.FormatStyle.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * Floats - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float16>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * Floats - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float32>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * Floats - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<FloatingPointFormatStyle<Float64>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * Ints
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * Ints - 8
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int8>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * Ints - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int16>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * Ints - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int32>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * Ints - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<Int64>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * UInts
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * UInts - 8
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt8>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * UInts - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt16>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * UInts - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt32>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}

//*============================================================================*
// MARK: * UInts - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<IntegerFormatStyle<UInt64>.Percent> {
    @inlinable static var percent: Self { Self(format: .percent) }
}
