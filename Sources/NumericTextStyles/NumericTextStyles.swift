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

//*============================================================================*
// MARK: * Floats - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Float16.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float16.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * Floats - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Float32.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float32.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * Floats - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Float64.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float64.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * Ints
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Int.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * Ints - 8
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Int8.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int8.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * Ints - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Int16.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int16.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * Ints - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Int32.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int32.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * Ints - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<Int64.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int64.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * UInts
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<UInt.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * UInts - 8
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<UInt8.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt8.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * UInts - 16
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<UInt16.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt16.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * UInts - 32
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<UInt32.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt32.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}

//*============================================================================*
// MARK: * UInts - 64
//*============================================================================*

public extension DiffableTextStyle where Self == NumericTextStyle<UInt64.FormatStyle> {
    @inlinable static var number: Self { Self(format: .number) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt64.FormatStyle.Currency> {
    @inlinable static func currency(code: String) -> Self { Self(format: .currency(code: code)) }
}
