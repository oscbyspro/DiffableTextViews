//
//  NumericTextStyles.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import DiffableTextViews
import struct Foundation.Decimal

// MARK: - UInts

public extension DiffableTextStyle where Self == NumericTextStyle<UInt> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt8> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt16> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt32> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt64> {
    @inlinable static var number: Self { .init() }
}

// MARK: - Ints

public extension DiffableTextStyle where Self == NumericTextStyle<Int> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int8> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int16> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int32> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int64> {
    @inlinable static var number: Self { .init() }
}

// MARK: - Floats

public extension DiffableTextStyle where Self == NumericTextStyle<Float16> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float32> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float64> {
    @inlinable static var number: Self { .init() }
}

// MARK: - Decimals

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal> {
    @inlinable static var number: Self { .init() }
}
