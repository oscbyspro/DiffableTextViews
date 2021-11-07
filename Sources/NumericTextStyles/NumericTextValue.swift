//
//  NumericTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import Foundation
import DiffableTextViews

public protocol NumericTextValue: Boundable, Precise, Formattable {
    typealias NumericTextStyle = NumericTextStyles.NumericTextStyle<Self>
}

// MARK: - Values: Int

public extension DiffableTextStyle where Self == NumericTextStyle<Int> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int8> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int16> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int32> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int64> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

// MARK: - Values: UInt

public extension DiffableTextStyle where Self == NumericTextStyle<UInt> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt8> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt16> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt32> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt64> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

// MARK: - Values: Float

public extension DiffableTextStyle where Self == NumericTextStyle<Float16> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float32> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float64> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}

// MARK: - Values: Decimal

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal> {
    @inlinable static func numeric(locale: Locale = .autoupdatingCurrent) -> Self { .init(locale: locale) }
}
